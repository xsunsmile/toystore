require 'helper'

describe Toy::AssociationSerialization do
  uses_constants('User', 'Game', 'Move')

  before do
    User.attribute :name, String
    User.attribute :age, Integer
  end

  describe "serializing relationships" do
    before do
      User.list :games, :inverse_of => :user
      Game.reference :user
    end

    it "should include references" do
      user = User.create(:name => 'John', :age => 28)
      game = user.games.create

      MultiJson.load(game.to_json(:include => [:user])).should == {
        'game' => {
          'id'      => game.id,
          'user_id' => user.id,
          'user'    => {
            'name'     => 'John',
            'game_ids' => [game.id],
            'id'       => user.id,
            'age'      => 28,
          }
        }
      }
    end

    it "should include lists" do
      user = User.create(:name => 'John', :age => 28)
      game = user.games.create
      MultiJson.load(user.to_json(:include => [:games])).should == {
        'user' => {
          'name'     => 'John',
          'game_ids' => [game.id],
          'id'       => user.id,
          'age'      => 28,
          'games'    => [{'id' => game.id, 'user_id' => user.id}],
        }
      }
    end

    it "should not cause circular reference JSON errors for references" do
      user = User.create(:name => 'John', :age => 28)
      game = user.games.create

      MultiJson.load(ActiveSupport::JSON.encode(game.user)).should == {
        'user' => {
          'name'     => 'John',
          'game_ids' => [game.id],
          'id'       => user.id,
          'age'      => 28
        }
      }
    end

    it "should not cause circular reference JSON errors for references when called indirectly" do
      user = User.create(:name => 'John', :age => 28)
      game = user.games.create

      MultiJson.load(ActiveSupport::JSON.encode([game.user])).should == [
        'user' => {
          'name'     => 'John',
          'game_ids' => [game.id],
          'id'       => user.id,
          'age'      => 28
        }
      ]
    end

    it "should not cause circular reference JSON errors for lists" do
      user = User.create(:name => 'John', :age => 28)
      game = user.games.create

      MultiJson.load(ActiveSupport::JSON.encode(user.games)).should ==  [{
        'game' => {
          'id'      => game.id,
          'user_id' => user.id
        }
      }]
    end

    it "should not cause circular reference JSON errors for lists when called indirectly" do
      user = User.create(:name => 'John', :age => 28)
      game = user.games.create

      MultiJson.load(ActiveSupport::JSON.encode({:games => user.games})).should ==  {
        'games' => [{
          'game' => {
            'id'      => game.id,
            'user_id' => user.id
          }
        }]
      }
    end
  end
end
