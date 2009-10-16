require File.dirname(__FILE__) + '/spec_helper'

describe "ronin" do
  let(:connection) do
    EY::Ronin::Connection.new
  end

  it "knows the running instances" do
    connection.instances.should_not be_empty
  end

  it "knows the aws security groups" do
    connection.groups.should_not be_empty
  end

  it "help for the environment names" do
    lambda { connection.help }.should_not raise_error
  end

  it "logs into an environment named sshtesting" do
    lambda { connection.login_to_environment('sshtesting') }.should_not raise_error
  end
end
