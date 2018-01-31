module DB
  class Query
    attr_reader :sql, :returns

    def initialize(sql:, returns: :many)
      @sql = sql
      @returns = Returns.new(returns)
    end

    def method_missing(method, *args, &block)
      sql.send(method, *args, &block)
    end

    def returning(&block)
      block.call(returns)
    end

    Returns = Struct.new(:returns) do
      def one(&block)
        block.call if returns == :one
      end

      def many(&block)
        block.call if returns == :many
      end
    end
  end
end
