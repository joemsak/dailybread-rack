require_relative "records"

module DB
  class Query
    def initialize(sql:, returns: :many)
      @sql = sql
      @returns = returns
    end

    def sql
      @sql.split(" ").join(" ")
    end

    def method_missing(method, *args, &block)
      sql.send(method, *args, &block)
    end

    def handle_result(result)
      case @returns
      when :one
        ::DB::Record.new(result)
      when :many
        ::DB::Records.new(result)
      end
    end
  end
end
