require 'right_aws'
require 'erb'
require 'tmpdir'

module EY
  module Ronin
    class Connection
      attr_reader :config
      def initialize(config = File.expand_path("~/.ey-cloud.yml"))
        @config ||= YAML.load_file(config)
        @ec2 ||= RightAws::Ec2.new(@config[:aws_secret_id],
                                   @config[:aws_secret_key])
      end

      def instances
        @instances ||= @ec2.describe_instances
      end

      def help
        puts "Here are the available environments:"
        groups.keys.each do |group|
          puts "  - #{group}"
        end
      end

      def groups
        groups = Hash.new { |h,k| h[k] = [ ] }
        instances.each do |instance|
          instance[:aws_groups].each do |group|
            name = group.sub(/^ey-([^-]+)-.*?$/, '\1')
            groups[name] << instance.merge(:user => 'ey')
          end
        end
        groups
      end

      def template_file
        File.join(File.dirname(__FILE__), 'templates', 'applescript.scpt.erb')
      end

      def login_to_environment(name)
        @login_instances = groups[name].map { |instance| instance[:user] + '@' + instance[:dns_name] }
        template = ERB.new(File.read(template_file))
        script_content = template.result(binding)
        script_filename = "#{Dir.tmpdir}/ey-ec2-#{name}.terminals.applescript"
        File.open(script_filename, 'w') do |fp|
          fp.write script_content
        end
        %x{osascript "#{script_filename}"}
      end

      def command_for(instance)
        "clear; echo 'Opening for #{instance}'; ssh #{instance}"
      end
    end
  end
end
