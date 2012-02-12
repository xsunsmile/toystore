module Toy
  module Reloadable
    def reload
      if attrs = adapter.read(id)
        attrs['id'] = id
        instance_variables.each        { |ivar| instance_variable_set(ivar, nil) }
        initialize_attributes_with_defaults
        send(:attributes=, attrs, new_record?)
        self.class.lists.each_key      { |name| send(name).reset }
        self.class.references.each_key { |name| send(name).reset }
      else
        raise NotFound.new(id)
      end
      self
    end
  end
end