require 'helper'

describe Toy::Cloneable do
  uses_constants('User')

  before do
    User.attribute(:name, String)
    User.attribute(:skills, Array)

    @user = User.create({
      :name   => 'John',
      :skills => ['looking awesome', 'growing beards'],
    })
  end
  let(:user)  { @user }

  describe "#clone" do
    it "returns new instance" do
      user.clone.should be_new_record
    end

    it "has no changes" do
      user.clone.should_not be_changed
    end

    it "is never destroyed" do
      user.destroy
      user.clone.should_not be_destroyed
    end

    it "clones the @attributes hash" do
      user.clone.instance_variable_get("@attributes").should_not equal(user.instance_variable_get("@attributes"))
    end

    it "copies the attributes" do
      user.clone.tap do |clone|
        clone.name.should == user.name
        clone.skills.should == user.skills
      end
    end

    it "clones duplicable attributes" do
      user.clone.skills.should_not equal(user.skills)
    end

    it "regenerates id" do
      user.clone.tap do |clone|
        clone.id.should_not be_nil
        clone.id.should_not == user.id
      end
    end

    it "nullifies defined instance variables" do
      user.instance_variable_set("@foo", true)
      user.clone.tap do |clone|
        clone.instance_variable_get("@foo").should be_nil
      end
    end
  end
end