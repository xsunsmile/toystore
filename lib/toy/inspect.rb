module Toy
  module Inspect
    extend ActiveSupport::Concern

    module ClassMethods
      def inspect
        keys = attributes.keys - ['id']
        nice_string = keys.sort.map do |name|
          type = attributes[name].type
          "#{name}:#{type}"
        end.join(" ")
        "#{name}(id:#{attributes['id'].type} #{nice_string})"
      end
    end

    def inspect
      attributes_as_nice_string = self.class.attributes.keys.map(&:to_s).sort.map do |name|
        "#{name}: #{read_attribute(name).inspect}"
      end.join(", ")
      "#<#{self.class}:#{object_id} #{attributes_as_nice_string}>"
    end
  end
end
