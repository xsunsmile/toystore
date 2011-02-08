require 'pp'
require 'pathname'
require 'rubygems'
require 'adapter/memcached'
require 'adapter/riak'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
$:.unshift(lib_path)
require 'toystore'

class User
  include Toy::Store
  identity_map_off # turning off so we can better illustrate read/write through caching stuff

  store :riak, Riak::Client.new['users']
  cache :memcached, Memcached.new

  attribute :email, String
end

user = User.create(:email => 'nunemaker@gmail.com')
# ToyStore WTS #<User:0x102810e18> :memcached "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"nunemaker@gmail.com"}
# ToyStore SET #<User:0x102810e18> :riak "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"nunemaker@gmail.com"}

user = User.get(user.id)
# Get hits memcache instead of riak since it is cached
# ToyStore RTG User :memcached "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"nunemaker@gmail.com"}

# delete from cache to demonstrate population on cache miss
user.cache.delete(user.id)

user = User.get(user.id)
# Attempt read again, misses memcache, hits riak, caches in memcache
# ToyStore RTG User :memcached "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   nil
# ToyStore GET User :riak "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"nunemaker@gmail.com"}
# ToyStore RTS User :memcached "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"nunemaker@gmail.com"}

user.update_attributes(:email => 'john@orderedlist.com')
# updated in memcache, then riak
# ToyStore WTS #<User:0x10266f0a0> :memcached "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"john@orderedlist.com"}
# ToyStore SET #<User:0x10266f0a0> :riak "6c39dd2a-3392-11e0-9fbf-040220ce8970"
#   {"email"=>"john@orderedlist.com"}
