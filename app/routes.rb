require 'json'

require_relative "router"

ROUTES = Router.new do
  post "/" do |body|
    json = JSON.parse(body.read)

    if json.values.empty?
      respond status: 400
    else
      DB.create_recurring_bill(json.values)
      respond DB.last_recurring_bill.to_json
    end
  end

  get "/" do
    respond DB.all_recurring_bills.to_json
  end
end
