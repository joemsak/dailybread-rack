require 'json'

class Router
  def initialize(&block)
    @routes = {
      "GET" => {},
      "POST" => {},
    }

    instance_eval(&block)
  end

  def respond(*args)
    body, opts = arrange_args(args)
    Response.new(body, opts[:status], opts[:headers])
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
      Rack::Response.new(resp.body, resp.status, resp.headers)
    else
      not_found
    end
  end

  def not_found
    Rack::Response.new({ error: "Not found" }.to_json, 404)
  end

  private
  def arrange_args(args)
    if args[0].is_a?(Hash)
      opts_idx = 0
      body = ""
    else
      body = args[0] || ""
      opts_idx = 1
    end

    args[opts_idx] ||= {}

    opts = {
      status: args[opts_idx].fetch(:status) { 200 },
      headers: args[opts_idx].fetch(:headers) { {} },
    }

    return body, opts
  end

  class Response
    attr_reader :body, :status, :headers

    def initialize(body, status, headers)
      @body = body
      @status = status
      @headers = headers
    end
  end
end
