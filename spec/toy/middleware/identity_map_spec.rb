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

  before do
    @enabled = Toy::IdentityMap.enabled
    Toy::IdentityMap.enabled = false
  end

  after do
    Toy::IdentityMap.enabled = @enabled
  end

  it "should delegate" do
    called = false
    mw = Toy::Middleware::IdentityMap.new lambda { |env|
      called = true
      [200, {}, nil]
    }
    mw.call({})
    called.should be_true
  end

  it "should enable identity map during delegation" do
    mw = Toy::Middleware::IdentityMap.new lambda { |env|
      Toy::IdentityMap.should be_enabled
      [200, {}, nil]
    }
    mw.call({})
  end

  class Enum < Struct.new(:iter)
    def each(&b)
      iter.call(&b)
    end
  end

  it "should enable IM for body each" do
    mw = Toy::Middleware::IdentityMap.new lambda { |env|
      [200, {}, Enum.new(lambda { |&b|
        Toy::IdentityMap.should be_enabled
        b.call "hello"
      })]
    }
    body = mw.call({}).last
    body.each { |x| x.should eql('hello') }
  end

  it "should disable IM after body close" do
    mw = Toy::Middleware::IdentityMap.new lambda { |env| [200, {}, []] }
    body = mw.call({}).last
    Toy::IdentityMap.should be_enabled
    body.close
    Toy::IdentityMap.should_not be_enabled
  end

  it "should clear IM after body close" do
    mw = Toy::Middleware::IdentityMap.new lambda { |env| [200, {}, []] }
    body = mw.call({}).last

    Toy::IdentityMap.repository['hello'] = 'world'
    Toy::IdentityMap.repository.should_not be_empty

    body.close

    Toy::IdentityMap.repository.should be_empty
  end

  context "with a successful request" do
    it "clear the identity map" do
      Toy::IdentityMap.should_receive(:clear).twice
      get '/'
    end
  end

  context "when the request raises an error" do
    it "clear the identity map" do
      Toy::IdentityMap.should_receive(:clear).once
      get '/fail' rescue nil
    end
  end
end