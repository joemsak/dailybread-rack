require 'securerandom'

module DB
  QUERIES = {
    all_recurring_bills: %(
      select * from recurring_bills;
    ),

    create_recurring_bill: %(
      insert into recurring_bills (name, amount_in_pennies, pay_period)
      values($1, $2, $3);
    ),

    last_recurring_bill: %(
      select * from recurring_bills order by id desc limit 1;
    ),
  }

  def self.connection
    @@connection ||= PG::Connection.new(dbname: ENV.fetch("DB_NAME"))
  end

  def self.method_missing(method, *args)
    sql = QUERIES.fetch(method)
    query(sql, *args)
  end

  def self.query(sql, *args)
    statement_name = SecureRandom.base64
    connection.prepare(statement_name, sql);
    result = connection.exec_prepared(statement_name, args.flatten);
    Records.new(result)
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
      if count > 1
        map(&:attrs).to_json
      else
        first.attrs.to_json
      end
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
