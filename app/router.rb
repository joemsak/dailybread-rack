#!/usr/bin/env ruby

require 'json'

class Router
  def self.call(env)
    req = Rack::Request.new env
    case req.path
    when "/"
      Rack::Response.new({ a: "b" }.to_json)
    else
      Rack::Response.new({ error: "Not found" }.to_json, 404)
    end
  end
end