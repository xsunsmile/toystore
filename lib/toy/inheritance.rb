module Toy
  module Inheritance
    extend ActiveSupport::Concern

    module ClassMethods
      DuplicatedInstanceVariables = [
        :attributes,
        :key_factory,
        :lists,
        :references,
        :adapter,
      ]

      def inherited(subclass)
        DuplicatedInstanceVariables.each do |name|
          subclass.instance_variable_set("@#{name}", send(name).dup) if respond_to?(name)
        end

        subclass.attribute(:type, String, :default => subclass.name)

        super
      end
    end

    def type
      read_attribute(:type)
    end
  end
end
