require 'json'

class Router
  def initialize(&block)
    @routes = {
      "GET" => {},
      "POST" => {},
    }

    instance_eval(&block)
  end

  def get(path, &block)
    @routes["GET"][path] = block
  end

  def post(path, &block)
    @routes["POST"][path] = block
  end

  def call(env)
    req = Rack::Request.new(env)

    if callable = @routes[req.request_method][req.path]
      resp = callable.call(req.body)
      Rack::Response.new(resp.body, resp.status_code, resp.headers)
    else
      not_found
    end
  end

  def not_found
    Rack::Response.new({ error: "Not found" }.to_json, 404)
  end

  class ErrorResponse
    attr_reader :body, :status_code, :headers

    def initialize(status_code)
      @status_code = status_code
      @body = ""
      @headers = {}
    end
  end

  class ValidResponse
    attr_reader :body, :status_code, :headers

    def initialize(body)
      @body = body
      @status_code = 200
      @headers = {}
    end
  end
end
