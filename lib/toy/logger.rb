module Toy
  module Logger
    extend ActiveSupport::Concern

    module ClassMethods
      def logger
        Toy.logger
      end
    end

    def logger
      Toy.logger
    end
  end
end