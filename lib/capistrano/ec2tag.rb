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

            @target_instances = ec2_instances('deploy') unless @target_instances

            servers = @target_instances[which] || []
            if idxs = fetch(:server_idxs, nil)
              servers = servers.sort_by { |x| x[2] || x[3] }.each_with_index.select { |x, idx| idxs.include? idx + 1 }.map(&:first)
            end
            servers.map do |ip, status, name, _private_ip|
              logger.info "adding server #{name || ip}, #{args.join(', ')} "
              server ip, *args if status == :running
              name || ip
            end
          end

          def ec2_instances(tag)
            force_pvt_ip = fetch(:aws_force_pvt_ip, false)

            AWS.memoize do
              return @ec2.instances.filter('tag-key', tag).inject({}) do |res,instance|
                tag_name = instance.tags.to_h[tag]
                res[tag_name] ||= []
                ip_address = if force_pvt_ip
                               instance.private_ip_address
                             else
                               instance.ip_address || instance.private_ip_address
                             end
                # [ip_address, status, Name tag, private_ip_address]
                res[tag_name] << [ ip_address, instance.status, instance.tags['Name'], instance.private_ip_address ]
                res
              end
            end
          end

        end
      end
    end

    def self.read_from_credential_file(key_name, credential_file_name)
      if credential_file_name
        File.open(credential_file_name).readlines.select { |line| line =~ /^#{key_name}=/ }.map { |line| line[/=(.+)$/, 1] }.first
      end
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

