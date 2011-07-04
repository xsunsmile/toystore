require 'helper'

describe Toy::Logger do
  uses_constants('User')

  it "should use Toy.logger for class" do
    User.logger.should == Toy.logger
  end

  it "should use Toy.logger for instance" do
    User.new.logger.should == Toy.logger
  end

  describe ".log_operation" do
    let(:adapter) { Adapter[:memory].new({}) }

    it "logs operation" do
      User.logger.should_receive(:debug).with('TOYSTORE GET User :memory "foo"')
      User.log_operation(:get, User, adapter, 'foo', 'bar')
    end
  end

  describe "#log_operation" do
    let(:adapter) { Adapter[:memory].new({}) }

    it "logs operation" do
      User.logger.should_receive(:debug).with('TOYSTORE GET User :memory "foo"')
      User.log_operation(:get, User, adapter, 'foo', 'bar')
    end
  end
end