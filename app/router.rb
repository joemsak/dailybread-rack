#!/usr/bin/env ruby

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
      callable.call(req.body)
    else
      not_found
    end
  end

  def not_found
    Rack::Response.new({ error: "Not found" }.to_json, 404)
  end
end

ROUTER = Router.new do
  post "/" do |body|
    json = JSON.parse(body.read)
    DB.create_recurring_bill(json.values)
    Rack::Response.new(DB.last_recurring_bill.to_json)
  end

  get "/" do
    Rack::Response.new(DB.all_recurring_bills.to_json)
  end
end
