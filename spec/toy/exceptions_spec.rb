require 'helper'

describe Toy::RecordInvalid do
  uses_constants('User')

  before do
    User.attribute(:name, String)
    User.attribute(:age, Integer)
    User.validates_presence_of(:name)
    User.validates_presence_of(:age)
  end
  
  it "should include a message of the errors" do
    user = User.new
    user.should_not be_valid
    Toy::RecordInvalid.new(user).message.should == "Invalid record: Name can't be blank and Age can't be blank"
  end
end