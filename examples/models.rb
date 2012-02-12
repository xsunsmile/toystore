require 'pathname'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
$:.unshift(lib_path)

require 'toy'
require 'adapter/memory'

class Address
  include Toy::Store
  adapter :memory, {}

  attribute :city,  String
  attribute :state, String
  attribute :zip,   String
end

class PhoneNumber
  include Toy::Store

  attribute :area_code, String
  attribute :number,    String
end

class Company
  include Toy::Store
  adapter :memory, {}

  attribute :name, String
end

class User
  include Toy::Store
  adapter :memory, {}

  attribute :name,  String
  attribute :age,   Integer
  attribute :admin, Boolean, :default => false
  attribute :ssn,   String
  timestamps

  list :addresses, :dependendent => true
  reference :employer, Company

  # validations and callbacks are available too
end