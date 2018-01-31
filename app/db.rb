module DB
  QUERIES = {
    all_recurring_bills: %(
      select * from recurring_bills;
    ),
  }

  def self.connection
    @@connection ||= PG::Connection.new(dbname: ENV.fetch("DB_NAME"))
  end

  def self.method_missing(method)
    sql = QUERIES.fetch(method)
    query(sql)
  end

  def self.query(sql)
    Records.new(connection.exec(sql))
  end

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
      map(&:attrs).to_json
    end
  end

  class Record
    attr_reader :attrs

    def initialize(attrs)
      @attrs = attrs
    end

    def method_missing(method)
      @attrs.fetch(method.to_s)
    end
  end
end
