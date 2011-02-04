require 'pp'
require 'pathname'
require 'rubygems'
require 'adapter/memcached'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
$:.unshift(lib_path)
require 'toystore'

class GameList
  include Toy::Store
  store :memcached, Memcached.new

  attribute :source, Hash
end

list = GameList.create(:source => {'foo' => 'bar'})

pp list
pp GameList.get(list.id)

list.destroy

pp GameList.get(list.id)