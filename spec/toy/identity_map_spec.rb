require 'helper'

describe Toy::IdentityMap do
  uses_constants('User', 'Skill')

  before do
    Toy::IdentityMap.enabled = true
    Toy::IdentityMap.clear
  end

  after do
    Toy::IdentityMap.enabled = false
  end

  it "adds to map on save" do
    user = User.new
    user.save!
    user.should be_in_identity_map
  end

  it "adds to map on load" do
    user = User.load('1', 'id' => '1')
    user.should be_in_identity_map
  end

  it "removes from map on delete" do
    user = User.create
    user.should be_in_identity_map
    user.delete
    user.should_not be_in_identity_map
  end

  it "removes from map on destroy" do
    user = User.create
    user.should be_in_identity_map
    user.destroy
    user.should_not be_in_identity_map
  end

  describe ".get" do
    it "adds to map if not in map" do
      user = User.create
      Toy::IdentityMap.clear
      user.should_not be_in_identity_map
      user = User.get(user.id)
      user.should be_in_identity_map
    end

    it "returns from map if in map" do
      user = User.create
      user.should be_in_identity_map
      User.get(user.id).should equal(user)
    end

    it "does not query if in map" do
      user = User.create
      user.should be_in_identity_map
      user.adapter.should_not_receive(:read)
      User.get(user.id).should equal(user)
    end
  end

  describe "#reload" do
    it "forces new query each time and skips the identity map" do
      user = User.create
      user.should be_in_identity_map
      User.adapter.should_receive(:read).with(user.id).and_return({})
      user.reload
    end
  end

  describe "identity map off" do
    it "does not add to map on save" do
      Toy::IdentityMap.enabled = false
      user = User.new
      user.save!
      user.should_not be_in_identity_map
    end

    it "does not add to map on load" do
      Toy::IdentityMap.enabled = false
      user = User.load('1', 'name' => 'John')
      user.should_not be_in_identity_map
    end

    it "does not remove from map on delete" do
      user = User.create
      user.should be_in_identity_map
      Toy::IdentityMap.enabled = false
      user.delete
      user.should be_in_identity_map
    end

    it "does not remove from map on destroy" do
      user = User.create
      user.should be_in_identity_map
      Toy::IdentityMap.enabled = false
      user.destroy
      user.should be_in_identity_map
    end

    describe ".get" do
      it "does not add to map if not in map" do
        Toy::IdentityMap.enabled = false
        user = User.create
        user.should_not be_in_identity_map
        user = User.get(user.id)
        user.should_not be_in_identity_map
      end

      it "does not load from map if in map" do
        user = User.create
        user.should be_in_identity_map
        Toy::IdentityMap.enabled = false
        user.adapter.should_receive(:read).with(user.id).and_return(user.persisted_attributes)
        User.get(user.id)
      end
    end
  end
end