require 'securerandom'

require_relative "db/query"
require_relative "db/queries"
require_relative "db/records"

module DB
  def self.connection
    @@connection ||= PG::Connection.new(dbname: ENV.fetch("DB_NAME"))
  end

  def self.method_missing(method, *args)
    sql = QUERIES.fetch(method)
    query(sql, *args)
  end

  def self.query(sql, *args)
    statement_name = SecureRandom.base64
    formatted = sql.split(" ").join(" ")

    connection.prepare(statement_name, formatted)

    result = connection.exec_prepared(statement_name, args.flatten);

    sql.returning do |returns|
      returns.one {
        return Record.new(
          result.fields.zip(result.values.flatten).to_h
        )
      }

      returns.many {
        return Records.new(result)
      }
    end
  end
end
