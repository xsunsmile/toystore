module Toy
  module Store
    extend ActiveSupport::Concern
    extend Plugins

    included do
      extend  ActiveModel::Naming
      include ActiveModel::Conversion
      include Attributes
      include Identity
      include Persistence
      include MassAssignmentSecurity
      include Cloneable
      include Dirty
      include DirtyStore
      include Equality
      include Inspect
      include Querying
      include Reloadable

      include Callbacks
      include Validations
      include Serialization
      include Timestamps

      include Lists
      include References
      include Logger

      include IdentityMap
      include Caching
    end
  end
end