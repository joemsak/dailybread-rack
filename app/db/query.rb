module DB
  class Query
    attr_reader :sql, :returns

    def initialize(sql:, returns: :many)
      @sql = sql
      @returns = Returns.new(returns)
    end

    def method_missing(method, *args)
      sql.send(method, *args)
    end

    def returning(&block)
      block.call(returns)
    end

    class Returns < Struct.new(:returns)
      def one(&block)
        block.call if returns == :one
      end

      def many(&block)
        block.call if returns == :many
      end
    end
  end
end
