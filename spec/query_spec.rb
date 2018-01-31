ENV["RACK_ENV"] = "test"

require 'bundler'
Bundler.require

require_relative "../app/db"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

RSpec.describe "DB Queries" do
  before(:all) do
    system("bin/reset")
  end

  it "returns billing expenses" do
    DB.connection.exec("
      insert into recurring_bills (name, amount_in_pennies, pay_period)
      values('credit cards', 50000, 1);
    ")

    DB.connection.exec("
      insert into recurring_bills (name, amount_in_pennies, pay_period)
      values('savings', 50000, 1);
    ")

    results = DB.all_recurring_bills

    results.map(&:name).should == ["credit cards", "savings"]
  end
end
