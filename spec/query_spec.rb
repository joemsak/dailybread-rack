require "spec_helper"

RSpec.describe "DB Queries" do
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
