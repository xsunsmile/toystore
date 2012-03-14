# require 'perftools'
require 'pp'
require 'logger'
require 'benchmark'
require 'rubygems'

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'toystore'
require 'adapter/memory'

Toy.logger = ::Logger.new(STDOUT).tap { |log| log.level = ::Logger::INFO }

class User
  include Toy::Store
  adapter(:memory, {})
end

times = 10_000
user = User.new
id = user.id
attrs = user.persisted_attributes

adapter_result = Benchmark.realtime {
  times.times { User.adapter.write(id, attrs) }
}
toystore_result = Benchmark.realtime {
  times.times { User.create }
}

puts 'Client', adapter_result
puts 'Toystore', toystore_result
puts 'Ratio', toystore_result / adapter_result
