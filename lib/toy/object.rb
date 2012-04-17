module Toy
  module Object
    extend ActiveSupport::Concern

    included do
      extend  ActiveModel::Naming
      include ActiveModel::Conversion
      include Attributes
      include Cloneable
      include Dirty
      include Equality
      include Inspect
      include Logger
    end

    def persisted?
      false
    end
  end
end
