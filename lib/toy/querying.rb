module Toy
  module Querying
    extend ActiveSupport::Concern

    module ClassMethods
      def get(id)
        key = store_key(id)
        value = store.read(key)
        log_operation(:get, self, store, key, value)
        load(key, value)
      end

      def get!(id)
        get(id) || raise(Toy::NotFound.new(id))
      end

      def get_multi(*ids)
        ids.flatten.map { |id| get(id) }
      end

      def get_or_new(id)
        get(id) || new(:id => id)
      end

      def get_or_create(id)
        get(id) || create(:id => id)
      end

      def key?(id)
        key = store_key(id)
        value = store.key?(key)
        log_operation(:key, self, store, key, value)
        value
      end
      alias :has_key? :key?

      def load(key, attrs)
        attrs && allocate.initialize_from_database(attrs.update('id' => key))
      end
    end
  end
end