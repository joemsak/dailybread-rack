require_relative "record"

module DB
  class Records
    include Enumerable

    attr_reader :result, :records

    def initialize(result)
      @result = result
      @records = result.values.map do |values|
        Record.new(result.fields.zip(values.flatten).to_h)
      end
    end

    def each(&block)
      records.each(&block)
    end

    def to_json
      if count > 1
        map(&:attrs).to_json
      elsif count == 1
        first.attrs.to_json
      else
        [].to_json
      end
    end

    def method_missing(method, *args, &block)
      records.send(method, *args, &block)
    end
  end
end
