module Toy
  module Middleware
    class IdentityMap
      class Body
        def initialize(target, original)
          @target   = target
          @original = original
        end

        def each(&block)
          @target.each(&block)
        end

        def close
          @target.close if @target.respond_to?(:close)
        ensure
          Toy::IdentityMap.enabled = @original
          Toy::IdentityMap.clear
        end
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        Toy::IdentityMap.clear
        enabled = Toy::IdentityMap.enabled
        Toy::IdentityMap.enabled = true
        status, headers, body = @app.call(env)
        [status, headers, Body.new(body, enabled)]
      end
    end
  end
end