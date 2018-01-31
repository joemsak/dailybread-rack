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

  it "creates recurring bills" do
    DB.create_recurring_bill("car payment", 36800, 2)

    result = DB.last_recurring_bill

    result.id.should_not be_nil
    result.name.should == "car payment"
    result.amount_in_pennies.should == "36800"
    result.pay_period.should == "2"
  end

  it "returns the last recurring bill" do
    DB.create_recurring_bill("car payment", 36800, 2)
    DB.create_recurring_bill("car insurance", 27400, 1)

    result = DB.last_recurring_bill

    result.id.should_not be_nil
    result.name.should == "car insurance"
    result.amount_in_pennies.should == "27400"
    result.pay_period.should == "1"
  end

  it "returns empty records when they don't exist" do
    DB.last_recurring_bill.id.should == nil
    DB.last_recurring_bill.name.should == nil
    DB.last_recurring_bill.amount_in_pennies.should == nil
    DB.last_recurring_bill.pay_period.should == nil
  end

  it "returns empty collections for empty query results" do
    DB.all_recurring_bills.to_json.should == "[]"
  end
end
