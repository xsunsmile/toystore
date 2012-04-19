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
      keys = self.class.attributes.keys - ['id']
      attributes_as_nice_string = keys.map(&:to_s).sort.map do |name|
        "#{name}: #{read_attribute(name).inspect}"
      end
      attributes_as_nice_string.unshift("id: #{read_attribute(:id).inspect}")
      "#<#{self.class}:#{object_id} #{attributes_as_nice_string.join(', ')}>"
    end
  end
end
