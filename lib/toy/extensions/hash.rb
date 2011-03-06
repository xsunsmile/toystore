module Toy
  module Extensions
    module Hash
      def store_default
        {}
      end

      def from_store(value, *)
        value.nil? ? store_default : value
      end
    end
  end
end

class Hash
  extend Toy::Extensions::Hash
end