module Toy
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def adapter(name=nil, client=nil, options={})
        assert_client(name, client)
        if !name.nil? && !client.nil?
          @adapter = Adapter[name].new(client, options)
        end
        assert_adapter(name, client)
        @adapter
      end

      def has_adapter?
        !@adapter.nil?
      end

      def create(attrs={})
        new(attrs).tap { |doc| doc.save }
      end

      def delete(*ids)
        ids.each { |id| get(id).try(:delete) }
      end

      def destroy(*ids)
        ids.each { |id| get(id).try(:destroy) }
      end

      private

      def assert_client(name, client)
        raise(ArgumentError, 'Client is required') if !name.nil? && client.nil?
      end

      def assert_adapter(name, client)
        raise(StandardError, "No adapter has been set") if name.nil? && client.nil? && !has_adapter?
      end
    end

    def adapter
      self.class.adapter
    end

    def initialize_from_database(attrs={})
      @_new_record = false
      send(:initialize, attrs)
      self
    end

    def new_record?
      @_new_record == true
    end

    def destroyed?
      @_destroyed == true
    end

    def persisted?
      !new_record? && !destroyed?
    end

    def save(*)
      new_record? ? create : update
    end

    def update_attributes(attrs)
      self.attributes = attrs
      save
    end

    def destroy
      delete
    end

    def delete
      @_destroyed = true
      adapter.delete(id)
    end

    private

    def create
      persist!
    end

    def update
      persist!
    end

    def persist
      @_new_record = false
    end

    def persist!
      attrs = persisted_attributes
      attrs.delete('id') # no need to persist id as that is key
      adapter.write(id, attrs)
      persist
      true
    end
  end
end