require 'capistrano'
require 'aws-sdk'

module Capistrano
  module Ec2tag
    def self.extend(configuration)
      configuration.load do
        Capistrano::Configuration.instance.load do
          _cset(:access_key_id, ENV['AWS_ACCESS_KEY_ID'])
          _cset(:secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])

          def tag(which, *args)
            @ec2 ||= AWS::EC2.new({access_key_id: fetch(:aws_access_key_id), secret_access_key: fetch(:aws_secret_access_key)}.merge! fetch(:aws_params, {}))

            @target_instances = ec2_instances('deploy') unless @target_instances

            if @target_instances[which]
              @target_instances[which].each do |ip, status|
                server ip, *args if status == :running
              end
            end
          end

          def ec2_instances(tag)
            AWS.memoize do
              return @ec2.instances.filter('tag-key', tag).inject({}) do |res,instance|
                tag_name = instance.tags.to_h[tag]
                res[tag_name] ||= []
                res[tag_name] << [ instance.private_ip_address, instance.status]
                res
              end
            end
          end

        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Ec2tag.extend(Capistrano::Configuration.instance)
end

