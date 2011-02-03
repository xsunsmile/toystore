require 'helper'
require 'toy/identity/object_id_key_factory'

describe Toy::Identity::ObjectIdKeyFactory do
  it "should use object id for next key" do
    key = Toy::Identity::ObjectIdKeyFactory.new.next_key(nil)
    key.should be_instance_of(BSON::ObjectId)
  end
end