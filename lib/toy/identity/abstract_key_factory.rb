module Toy
  module Identity
    class AbstractKeyFactory
      def key_type
        raise NotImplementedError, "#{self.class.name}.store_type isn't implemented."
      end

      def next_key(object)
        raise NotImplementedError, "#{self.class.name}#next_key isn't implemented."
      end
    end
  end
end

