require 'helper'

describe Toy::Equality do
  uses_constants('User', 'Game', 'Person')

  describe "#eql?" do
    it "returns true if same class and id" do
      User.new(:id => 1).should eql(User.new(:id => 1))
    end

    it "return false if different class" do
      User.new(:id => 1).should_not eql(Person.new(:id => 1))
    end

    it "returns false if different id" do
      User.new(:id => 1).should_not eql(User.new(:id => 2))
    end
  end

  describe "equal?" do
    it "returns true if same object" do
      user = User.create(:id => 1)
      user.should equal(user)
    end

    it "returns false if not same object" do

    end
  end
end