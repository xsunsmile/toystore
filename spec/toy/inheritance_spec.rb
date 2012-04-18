require 'helper'

describe 'Toy Inheritance' do
  describe 'using Toy::Object' do
    uses_objects('Parent')

    attr_reader :inherited_class

    before do
      Parent.attribute :name, String

      @inherited_class = Class.new(Parent) do
        class << self
          def name
            'SomeInheritedClass'
          end

          def to_s
            name
          end
        end
      end
    end

    it "duplicates attributes" do
      Parent.attributes.each do |name, attribute|
        inherited_class.attributes.key?(name).should be_true
        inherited_class.attributes[name].should eq(Parent.attributes[name])
      end
    end

    it "does not add attributes to the parent" do
      inherited_class.attribute(:foo, String)
      Parent.attributes.keys.should_not include(:foo)
    end

    it "adds type attribute" do
      inherited_class.attribute?(:type).should be_true
    end

    it "sets type to class name" do
      inherited_class.new.type.should eq('SomeInheritedClass')
    end

    it "sets the key factory to same as parent" do
      inherited_class.key_factory.should eq(Parent.key_factory)
    end
  end

  describe 'using Toy::Store' do
    uses_constants('Parent', 'Degree')

    attr_reader :inherited_class

    before do
      Parent.attribute  :name,    String
      Parent.list       :degrees, Degree
      Parent.reference  :degree,  Degree

      @inherited_class = Class.new(Parent) do
        class << self
          def name
            'SomeInheritedClass'
          end

          def to_s
            name
          end
        end
      end

      @inherited_class.list       :odd_degrees, Degree
      @inherited_class.reference  :odd_degree,  Degree
    end

    it "duplicates lists" do
      inherited_class.lists.keys.should include(:degrees)
      inherited_class.lists.keys.should include(:odd_degrees)
    end

    it "does not add lists to parent" do
      Parent.lists.keys.should_not include(:odd_degrees)
    end

    it "duplicates references" do
      inherited_class.references.keys.should include(:degree)
      inherited_class.references.keys.should include(:odd_degree)
    end

    it "does not add references to parent" do
      Parent.references.keys.should_not include(:odd_degree)
    end

    it "sets the adapter to the same as the parent" do
      inherited_class.adapter.should eq(Parent.adapter)
    end
  end
end
