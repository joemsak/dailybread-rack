ENV["RACK_ENV"] ||= "development"
ENV["DB_NAME"] ||= "dailybread_#{ENV.fetch("RACK_ENV")}"

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
    result = connection.exec(sql)

    result.values.map do |values|
      Record.new(result.fields.zip(values.flatten).to_h)
    end
  end

  class Record
    def initialize(attrs)
      @attrs = attrs
    end

    def method_missing(method)
      @attrs.fetch(method.to_s)
    end
  end
end
