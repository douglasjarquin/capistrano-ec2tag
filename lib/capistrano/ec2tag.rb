require 'aws-sdk'

unless Capistrano::Configuration.respond_to?(:instance)
  abort 'capistrano/ec2tag requires Capistrano >= 2'
end

module Capistrano
  class Configuration
    module Tags

      def tag(which, *args)
        @ec2 ||= AWS::EC2.new({access_key_id: fetch(:aws_access_key_id), secret_access_key: fetch(:aws_secret_access_key)}.merge! fetch(:aws_params, {}))

        @ec2.instances.filter('tag-key', 'deploy').filter('tag-value', which).each do |instance|
          server instance.dns_name || instance.ip_address, *args if instance.status == :running
        end
      end

    end

    include Tags
  end
end
