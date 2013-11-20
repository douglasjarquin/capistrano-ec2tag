require 'capistrano'
require 'aws-sdk'
module Capistrano
  module Ec2tag
    def self.extend(configuration)
      configuration.load do
        Capistrano::Configuration.instance.load do
          _cset(:aws_credential_file, ENV['AWS_CREDENTIAL_FILE'])

          _cset(:aws_access_key_id) { ENV['AWS_ACCESS_KEY_ID'] || Capistrano::Ec2tag.read_from_credential_file('AWSAccessKeyId', fetch(:aws_credential_file)) }
          _cset(:aws_secret_access_key) { ENV['AWS_SECRET_ACCESS_KEY'] || Capistrano::Ec2tag.read_from_credential_file('AWSSecretKey', fetch(:aws_credential_file))}

          def tag(which, *args)
            @ec2 ||= AWS::EC2.new({access_key_id: fetch(:aws_access_key_id), secret_access_key: fetch(:aws_secret_access_key)}.merge! fetch(:aws_params, {}))

            servers = @ec2.instances.filter('tag-key', 'deploy').filter('tag-value', which)
            if idxs = fetch(:server_idxs)
              servers = servers.sort_by { |x| x.tags['Name'] || x.private_ip_address }.each_with_index.select { |x, idx| idxs.include? idx + 1}.map(&:first)
            end
            servers.each do |instance|
              logger.info "adding server #{instance.tags['Name'] || instance.ip_address}, #{args.join(', ')} "
              server instance.ip_address || instance.private_ip_address, *args if instance.status == :running
            end
          end
        end
      end
    end

    def self.read_from_credential_file(key_name, credential_file_name)
      File.open(credential_file_name).readlines.select { |line| line =~ /^#{key_name}=/ }.map { |line| line[/=(.+)$/, 1] }.first
    end
  end
end

if Capistrano::Configuration.respond_to? :instance
  if Capistrano::Configuration.instance
    Capistrano::Ec2tag.extend(Capistrano::Configuration.instance)
  end
else
  load File.expand_path("../tasks/ec2tag.rake", __FILE__)
end

