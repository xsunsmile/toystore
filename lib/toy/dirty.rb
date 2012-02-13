module Toy
  module Dirty
    extend ActiveSupport::Concern
    include ActiveModel::Dirty

    def initialize(*)
      super
      # never register initial id assignment as a change
      @changed_attributes.delete('id') if @changed_attributes
    end

    def initialize_copy(*)
      super.tap do
        @previously_changed = {}
        @changed_attributes = {}
      end
    end

    def write_attribute(name, value)
      name    = name.to_s
      current = read_attribute(name)
      attribute_will_change!(name) if current != value
      super
    end
  end
end