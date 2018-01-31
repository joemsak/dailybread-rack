require "spec_helper"

require_relative "../app/router"

RSpec.describe "Routes" do
  describe "GET /" do
    it "returns all recurring bills" do
      DB.connection.exec("
        insert into recurring_bills (name, amount_in_pennies, pay_period)
        values('credit cards', 50000, 1);
      ")

      DB.connection.exec("
        insert into recurring_bills (name, amount_in_pennies, pay_period)
        values('savings', 25000, 1);
      ")

      resp = Router.call({ "PATH_INFO" => "/" })

      JSON.parse(resp.body[0]).map { |j| j['name'] }.should == [
        "credit cards",
        "savings",
      ]

      JSON.parse(resp.body[0]).map { |j| j['amount_in_pennies'] }.should == [
        "50000",
        "25000",
      ]
    end
  end
end
