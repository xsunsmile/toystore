require 'helper'
require 'rack/test'

describe Toy::Middleware::IdentityMap do
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.new do
      use Toy::Middleware::IdentityMap
      map "/" do
        run lambda {|env| [200, {}, []] }
      end
      map "/fail" do
        run lambda {|env| raise "FAIL!" }
      end
    end.to_app
  end

  context "with a successful request" do
    it "clear the identity map" do
      Toy.identity_map.should_receive(:clear).twice
      get '/'
    end
  end

  context "when the request raises an error" do
    it "clear the identity map" do
      Toy.identity_map.should_receive(:clear).twice
      get '/fail' rescue nil
    end
  end
end