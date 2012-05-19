require 'toy/proxies/list'

module Toy
  class List
    attr_accessor :model, :name, :options

    def initialize(model, name, *args, &block)
      @model   = model
      @name    = name.to_sym
      @options = args.extract_options!
      @type    = args.shift

      model.send(list_method)[name] = self

      options[:extensions] = modularized_extensions(block, options[:extensions])

      model.attribute(key, Array)
      create_accessors
    end

    def type
      @type ||= name.to_s.classify.constantize
    end

    def key
      @key ||= :"#{name.to_s.singularize}_ids"
    end

    def instance_variable
      @instance_variable ||= :"@_#{name}"
    end

    def new_proxy(owner)
      proxy_class.new(self, owner)
    end

    def extensions
      options[:extensions]
    end

    def eql?(other)
      self.class.eql?(other.class) &&
        model == other.model &&
        name  == other.name
    end
    alias :== :eql?

    private

    def proxy_class
      raise('Not Implemented')
    end

    def modularized_extensions(*extensions)
      extensions.flatten.compact.map do |extension|
        Proc === extension ? Module.new(&extension) : extension
      end
    end

    def proxy_class
      Toy::Proxies::List
    end

    def list_method
      :lists
    end

    def create_accessors
      model.class_eval """
        def #{name}
          #{instance_variable} ||= self.class.#{list_method}[:#{name}].new_proxy(self)
        end

        def #{name}=(records)
          #{name}.replace(records)
        end
      """

      if options[:dependent]
        model.class_eval """
          after_destroy :destroy_#{name}
          def destroy_#{name}
            #{name}.each { |o| o.destroy }
          end
        """
      end
    end
  end
end
