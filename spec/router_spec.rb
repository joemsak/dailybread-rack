require "spec_helper"
require "rack/test"

require_relative "../app/router"

RSpec.describe "Routes" do
  include Rack::Test::Methods

  def app
    app = ROUTER
    builder = Rack::Builder.new
    builder.run app
  end

  it "handles GET 404" do
    get("/foo/bar")
    last_response.status.should == 404
    JSON.parse(last_response.body)["error"].should == "Not found"
  end

  it "handles POST 404" do
    post("/foo/bar")
    last_response.status.should == 404
    JSON.parse(last_response.body)["error"].should == "Not found"
  end

  describe "GET /" do
    it "returns all recurring bills" do
      DB.create_recurring_bill("credit cards", 50_000, 1)
      DB.create_recurring_bill("savings", 25_000, 1)

      get("/")

      JSON.parse(last_response.body).map { |j| j['name'] }.should == [
        "credit cards",
        "savings",
      ]

      JSON.parse(last_response.body).map { |j|
        j['amount_in_pennies']
      }.should == [
        "50000",
        "25000",
      ]
    end
  end

  describe "POST /" do
    it "creates new recurring bills in the db" do
      post("/", JSON.generate({
        name: "car payment",
        amount_in_pennies: 36800,
        pay_period: 2,
      }),
      { 'CONTENT_TYPE' => 'application/json' })

      DB.last_recurring_bill.id.should_not be_nil
    end

    it "returns the created recurring bill" do
      post("/", JSON.generate({
        name: "car payment",
        amount_in_pennies: 36800,
        pay_period: 2,
      }),
      { 'CONTENT_TYPE' => 'application/json' })

      JSON.parse(last_response.body)["id"].should ==
        DB.last_recurring_bill.id
    end
  end
end
