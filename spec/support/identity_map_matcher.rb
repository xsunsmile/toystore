module IdentityMapMatcher
  class BeInIdentityMap
    def matches?(object)
      @object = object
      Toy::IdentityMap.include?(@object)
    end

    def failure_message
      "expected #{@object} to be in identity map, but it was not"
    end

    def negative_failure_message
      "expected #{@object} to not be in identity map, but it was"
    end
  end

  def be_in_identity_map
    BeInIdentityMap.new
  end
end