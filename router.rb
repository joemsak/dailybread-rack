#!/usr/bin/env ruby

require 'json'
require 'pg'

module DB
  def self.query(sql)
    conn = PG::Connection.open(dbname: 'dailybread')
    conn.exec(sql)
  end
end

puts DB.query("select * from recurring_bills").values

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
