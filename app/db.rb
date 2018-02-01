require_relative "db/queries"

module DB
  def self.connection
    @@connection ||= PG::Connection.new(dbname: ENV.fetch("DB_NAME"))
  end

  def self.method_missing(method, *args)
    query_spec = QUERIES.fetch(method)
    query(query_spec, *args)
  end

  def self.query(query_spec, *args)
    statement_name = Time.now.to_f.to_s

    connection.prepare(statement_name, query_spec.sql)

    result = connection.exec_prepared(statement_name, args.flatten);

    query_spec.handle_result(result)
  end
end
