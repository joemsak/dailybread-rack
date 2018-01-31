require 'bundler'
Bundler.require

require 'rack'
require_relative 'router'

use Rack::ContentType, "application/json"
use Rack::Reloader, 0

run Router
