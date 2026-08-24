namespace :ec2tag do


  task :tag, :which do |t, args|
    @ec2 ||= AWS::EC2.new({access_key_id: fetch(:aws_access_key_id), secret_access_key: fetch(:aws_secret_access_key), region: fetch(:aws_region, 'us-east-1')}.merge! fetch(:aws_params, {}))

    server_list = []
    if set_to = args.extras.last.delete(:set_to)
      server_list = fetch(set_to, server_list)
    end

    servers = @ec2.instances.filter('tag-key', 'deploy').filter('tag-value', args[:which])
    if idxs = fetch(:server_idxs, nil)
      servers = servers.sort_by { |x| x.tags['Name'] || x.private_ip_address }.each_with_index.select { |x, idx| idxs.include? idx + 1}.map(&:first)
    end
    servers.map do |instance|
      server_list << instance.tags['Name'] || instance.ip_address
      server instance.ip_address || instance.private_ip_address, *args.extras if instance.status == :running
    end
    unless set_to.nil?
      set set_to, server_list.uniq
    end

    ::Rake.application['ec2tag:tag'].reenable
  end

  before :tag, :aws_credentials do
    credential_file = fetch(:aws_credential_file, ENV['AWS_CREDENTIAL_FILE'])

    fetch(:aws_access_key_id) { -> { ENV['AWS_ACCESS_KEY_ID'] || Capistrano::Ec2tag.read_from_credential_file('AWSAccessKeyId', credential_file) } }

    fetch(:aws_secret_access_key) { -> { ENV['AWS_SECRET_ACCESS_KEY'] || Capistrano::Ec2tag.read_from_credential_file('AWSSecretKey', credential_file) } }
  end
end
