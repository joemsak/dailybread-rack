require 'json'

require_relative "router"

ROUTES = Router.new do
  post "/" do |body|
    json = JSON.parse(body.read)

    if json.values.empty?
      "error"
    else
      DB.create_recurring_bill(json.values)
      DB.last_recurring_bill.to_json
    end
  end

  get "/" do
    DB.all_recurring_bills.to_json
  end
end
