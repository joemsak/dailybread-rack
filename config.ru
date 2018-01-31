ENV["RACK_ENV"] ||= "development"
ENV["DB_NAME"] ||= "dailybread_#{ENV.fetch("RACK_ENV")}"

require 'bundler'
Bundler.require

require_relative "app/db"
require_relative 'app/routes'

use Rack::ContentType, "application/json"
use Rack::Reloader, 0

use Rack::Cors do
  allow do
    origins '*'
    resource '/*',
      headers: :any,
      methods: %i(get post options)
  end
end

run ROUTES
