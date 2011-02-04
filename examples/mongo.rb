require 'pp'
require 'rubygems'
require 'toystore'
require 'adapter/mongo'

class User
  include Toy::Store
  store :mongo, Mongo::Connection.new.db('adapter')['testing']

  attribute :name, String
end

user = User.create(:name => 'John')

pp user
pp User.get(user.id)

user.destroy

pp User.get(user.id)