module Toy
  module Cloneable
    extend ActiveSupport::Concern

    def initialize_copy(other)
      instance_variables.each do |name|
        instance_variable_set(name, nil)
      end

      @_new_record = true
      @_destroyed  = false
      @attributes  = {}

      other.attributes.except('id').each do |key, value|
        value = value.duplicable? ? value.clone : value
        send("#{key}=", value)
      end

      write_attribute(:id, self.class.next_key(self))
    end
  end
end