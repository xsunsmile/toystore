require 'bson'

module Toy
  module Identity
    class ObjectIdKeyFactory < AbstractKeyFactory
      def key_type
        BSON::ObjectId
      end

      def next_key(object)
        BSON::ObjectId.new
      end
    end
  end
end

class BSON::ObjectId
  def self.to_store(value, *)
    return value if value.is_a?(BSON::ObjectId)
    BSON::ObjectId.from_string(value.to_s)
  end

  def self.from_store(value, *args)
    to_store(value, *args)
  end
end