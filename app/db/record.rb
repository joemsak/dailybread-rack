module DB
  class Record
    attr_reader :attrs

    def initialize(result)
      if result.is_a?(PG::Result)
        @attrs = result.fields.zip(result.values.flatten).to_h
      elsif result.is_a?(Hash)
        @attrs = result
      end
    end

    def method_missing(method)
      @attrs.fetch(method.to_s)
    end

    def to_json
      attrs.to_json
    end
  end
end
