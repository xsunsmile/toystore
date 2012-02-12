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

      def store(*args)
        warn '[DEPRECATED] store is deprecated in favor of adapter'
        adapter(*args)
      end

      def has_adapter?
        !@adapter.nil?
      end

      def has_store?
        warn '[DEPRECATED] has_store? is deprecated in favor of has_adapter?'
        has_adapter?
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

    def store
      warn '[DEPRECATED] store is deprecated in favor of adapter'
      self.class.adapter
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
      log_operation(:del, self.class.name, adapter, id)
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
      log_operation(:set, self.class.name, adapter, id, attrs)
      persist
      each_embedded_object { |doc| doc.send(:persist) }
      true
    end
  end
end