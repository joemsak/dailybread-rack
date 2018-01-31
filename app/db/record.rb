module DB
  class Record
    attr_reader :attrs

    def initialize(attrs)
      @attrs = attrs
    end

    def method_missing(method)
      @attrs.fetch(method.to_s)
    end

    def to_json
      attrs.to_json
    end
  end
end
