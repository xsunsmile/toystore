module Toy
  module Querying
    extend ActiveSupport::Concern

    module ClassMethods
      def get(id)
        value = store.read(id)
        log_operation(:get, self, store, id, value)
        load(id, value)
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
        value = store.key?(id)
        log_operation(:key, self, store, id, value)
        value
      end
      alias :has_key? :key?

      def load(id, attrs)
        attrs && allocate.initialize_from_database(attrs.update('id' => id))
      end
    end
  end
end