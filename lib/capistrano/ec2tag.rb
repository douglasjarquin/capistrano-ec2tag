require 'right_aws'

unless Capistrano::Configuration.respond_to?(:instance)
  abort 'capistrano/ec2tag requires Capistrano >= 2'
end

module Capistrano
  class Configuration
    module Tags

      def tag(which, *args)
        @ec2 ||= RightAws::Ec2.new(fetch(:aws_access_key_id), fetch(:aws_secret_access_key), fetch(:aws_params, {}))

        @ec2.describe_instances(:filters => { 'tag-key' => 'deploy', 'tag-value' => "#{which}" }).each do |instance|
          server(instance[:dns_name].empty? ? instance[:ip_address] : instance[:dns_name], *args) unless instance[:aws_state] != 'running'
        end
      end

    end

    include Tags
  end
end

