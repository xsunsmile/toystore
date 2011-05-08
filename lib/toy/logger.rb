module Toy
  module Logger
    extend ActiveSupport::Concern

    module ClassMethods
      def logger
        Toy.logger
      end

      def log_operation(operation, model, adapter, key, value)
        if logger.debug?
          logger.debug("ToyStore #{operation.to_s.upcase} #{model} :#{adapter.name} #{key.inspect}")
          logger.debug("  #{value.inspect}")
        end
      end
    end

    module InstanceMethods
      def logger
        Toy.logger
      end

      def log_operation(*args)
        self.class.log_operation(*args)
      end
    end
  end
end