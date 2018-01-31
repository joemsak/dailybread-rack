require 'bundler'
Bundler.require

require_relative 'app/router'

use Rack::ContentType, "application/json"
use Rack::Reloader, 0

run Router
