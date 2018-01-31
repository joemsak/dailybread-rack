ENV["RACK_ENV"] = "test"
ENV["DB_NAME"] ||= "dailybread_#{ENV.fetch("RACK_ENV")}"

require 'bundler'
Bundler.require

require_relative "../app/db"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }

  config.before(:suite) do
    system("bin/reset")
  end

  config.after do
    DB.connection.exec("delete from recurring_bills;")
  end
end
