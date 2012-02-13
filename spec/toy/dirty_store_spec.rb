require 'helper'

describe Toy::DirtyStore do
  uses_constants('User')

  before do
    User.attribute(:name, String)
  end

  it "does not have changes when loaded from database" do
    user = User.create
    loaded = User.get(user.id)
    loaded.should_not be_changed
  end

  describe "#reload" do
    before      { @user = User.create(:name => 'John') }
    let(:user)  { @user }

    it "clears changes" do
      user.name = 'Steve'
      user.reload
      user.should_not be_changed
    end

    it "clears previously changed" do
      user.reload
      user.previous_changes.should be_empty
    end
  end

  describe "#save" do
    before      { @user = User.create(:name => 'Geoffrey') }
    let(:user)  { @user }

    it "clears changes" do
      user.name = 'John'
      user.should be_changed
      user.save
      user.should_not be_changed
    end

    it "sets previous changes" do
      user.previous_changes.should == {'name' => [nil, 'Geoffrey']}
    end
  end
end