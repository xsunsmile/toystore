require 'pp'
require 'rubygems'
require 'pathname'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
$:.unshift(lib_path)

require 'toystore'

class User
  include Toy::Store
  key :object_id
end

puts User.new.id # BSON::ObjectId ...
