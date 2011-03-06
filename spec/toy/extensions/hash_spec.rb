require 'helper'

describe "Hash.from_store" do
  it "should return hash" do
    Hash.from_store(:foo => 'bar')[:foo].should  == 'bar'
    Hash.from_store('foo' => 'bar')['foo'].should  == 'bar'
  end

  it "should be hash if nil" do
    hash = Hash.from_store(nil)
    hash.should == {}
  end
end

describe "Hash.store_default" do
  it "returns emtpy hash" do
    Hash.store_default.should == {}
  end
end