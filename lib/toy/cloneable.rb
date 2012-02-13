module Toy
  module Cloneable
    extend ActiveSupport::Concern

    def initialize_copy(other)
      @_new_record = true
      @_destroyed  = false
      @attributes = {}

      self.class.lists.each do |name, list|
        instance_variable_set(list.instance_variable, nil)
      end

      other.attributes.except('id').each do |key, value|
        value = value.duplicable? ? value.clone : value
        send("#{key}=", value)
      end

      write_attribute(:id, self.class.next_key(self))
    end
  end
end