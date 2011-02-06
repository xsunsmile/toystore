require 'helper'
require 'toy/identity/object_id_key_factory'

describe Toy::Identity::ObjectIdKeyFactory do
  uses_constants('User')

  it "should use BSON::ObjectId as key_type" do
    Toy::Identity::ObjectIdKeyFactory.new.key_type.should be(BSON::ObjectId)
  end

  it "should use object id for next key" do
    key = Toy::Identity::ObjectIdKeyFactory.new.next_key(nil)
    key.should be_instance_of(BSON::ObjectId)
  end

  describe "Declaring key to be object_id" do
    before(:each) do
      User.key(:object_id)
      User.attribute(:name, String)
    end

    it "returns BSON::ObjectId as .key_type" do
      User.key_type.should be(BSON::ObjectId)
    end

    it "sets id attribute to BSON::ObjectId type" do
      User.attributes['id'].type.should be(BSON::ObjectId)
    end

    it "correctly stores id in database" do
      user = User.create(:name => 'John')
      user.id.should be_instance_of(BSON::ObjectId)
      # key_for in memory adapter marshals non symbol/string keys
      # so we have to unmarshal to get the key type
      key =  Marshal.load(user.store.client.keys.first)
      key.should be_instance_of(BSON::ObjectId)
      user.id.should == key
    end
  end
end