require "spec_helper"
require "rack/test"

require_relative "../app/router"

RSpec.describe Router do
  include Rack::Test::Methods

  def app
    app = Router.new do
      get "/" do
        respond "you found it!"
      end

      get "/error" do
        respond status: 400
      end

      post "/" do
        respond "you created it!"
      end
    end

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

  it "handles an error response" do
    get("/error")
    last_response.status.should == 400
  end

  it "supports defined GET routes" do
    get("/")
    last_response.body.should == "you found it!"
  end

  it "supports defined POST routes" do
    post("/")
    last_response.body.should == "you created it!"
  end
end
