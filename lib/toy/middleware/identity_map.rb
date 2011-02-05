module Toy
  module Middleware
    class IdentityMap
      def initialize(app)
        @app = app
      end

      def call(env)
        Toy.identity_map.clear
        @app.call(env)
      ensure
        Toy.identity_map.clear
      end
    end
  end
end