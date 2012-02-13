require 'helper'

describe Toy::Logger do
  uses_objects('User')

  before do
    @logger = Toy.logger
  end

  after do
    Toy.logger = @logger
  end

  it "should use Toy.logger for class" do
    User.logger.should == Toy.logger
  end

  it "should use Toy.logger for instance" do
    User.new.logger.should == Toy.logger
  end
end