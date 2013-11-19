namespace :ec2tag do


  task :tag, :which do |t, args|
    @ec2 ||= AWS::EC2.new({access_key_id: fetch(:aws_access_key_id), secret_access_key: fetch(:aws_secret_access_key), region: fetch(:aws_region, 'us-east-1')}.merge! fetch(:aws_params, {}))

    @ec2.instances.filter('tag-key', 'deploy').filter('tag-value', args[:which]).each do |instance|
      server instance.ip_address || instance.private_ip_address, *args.extras if instance.status == :running
    end
  end

  before :tag, :aws_credentials do
    credential_file = fetch(:aws_credential_file, ENV['AWS_CREDENTIAL_FILE'])

    fetch(:aws_access_key_id) { -> { ENV['AWS_ACCESS_KEY_ID'] || Capistrano::Ec2tag.read_from_credential_file('AWSAccessKeyId', credential_file) } }

    fetch(:aws_secret_access_key) { -> { ENV['AWS_SECRET_ACCESS_KEY'] || Capistrano::Ec2tag.read_from_credential_file('AWSSecretKey', credential_file) } }
  end
end