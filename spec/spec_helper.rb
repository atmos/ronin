require 'pp'
Bundler.require_env(:test)
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'ronin'))

Spec::Runner.configure do |config|
end
