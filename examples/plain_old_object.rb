require 'pp'
require 'pathname'
require 'rubygems'
require 'adapter/memory'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
$:.unshift(lib_path)
require 'toystore'

##################################################################
# An example of all the goodies you get by including Toy::Object #
##################################################################

class Person
  include Toy::Object

  attribute :name, String
  attribute :age,  Integer
end

# Pretty class inspecting
puts Person.inspect

john = Person.new(:name => 'John', :age => 30)
steve = Person.new(:name => 'Steve', :age => 31)

# Pretty inspecting
puts john.inspect

# Attribute dirty tracking
john.name = 'NEW NAME!'
puts john.changes.inspect       # {"name"=>["John", "NEW NAME!"], "age"=>[nil, 30]}
puts john.name_changed?.inspect # true

# Equality goodies
puts john.eql?(john)  # true
puts john.eql?(steve) # false
puts john == john     # true
puts john == steve    # false

# Cloning
puts john.clone.inspect

# Inheritance
class AwesomePerson < Person
end

puts Person.attributes.keys.sort.inspect          # ["age", "id", "name"]
puts AwesomePerson.attributes.keys.sort.inspect   # ["age", "id", "name", "type"]

# Serialization
puts john.to_json
puts john.to_xml
