require 'pp'
require 'pathname'
require 'rubygems'
require 'adapter/memory'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
$:.unshift(lib_path)
require 'toystore'

# Identity map is turned on by default for Toystore. To turn it off for an entire model, just call identity_map_off.
#
# More Reading...
# http://martinfowler.com/eaaCatalog/identityMap.html
# http://en.wikipedia.org/wiki/Identity_map

class User
  include Toy::Store

  # identity_map_off # if uncommented, User would not use identity map

  attribute :name, String
end

user = User.create(:name => 'John')
# User is added to identity map
# ToyStore SET #<User:0x10220b4c8> :memory "08a1c54c-3393-11e0-8b37-89da41d2f675"
#   {"name"=>"John"}
# ToyStore IMS User "08a1c54c-3393-11e0-8b37-89da41d2f675"

User.get(user.id)
# User is retrieved from identity map instead of querying
# ToyStore IMG User "08a1c54c-3393-11e0-8b37-89da41d2f675"

User.without_identity_map do
  User.get(user.id)
  # User is queried from database
  # ToyStore GET User :memory "08a1c54c-3393-11e0-8b37-89da41d2f675"
  #   {"name"=>"John"}
end

User.get(user.id)
# User is retrieved from identity map instead of querying
# ToyStore IMG User "08a1c54c-3393-11e0-8b37-89da41d2f675"
