require 'bson'

module Toy
  module Identity
    class ObjectIdKeyFactory < AbstractKeyFactory
      def next_key(object)
        BSON::ObjectId.new
      end
    end
  end
end