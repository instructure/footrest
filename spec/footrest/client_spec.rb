require 'helper'

describe Footrest::Client do

  it "sets the domain" do
    client = Footrest::Client.new(domain:"http://domain.com")
    expect(client.domain).to eq("http://domain.com")

  end

  it "sets the authtoken" do
    client = Footrest::Client.new(token:"test_token")
    expect(client.token).to eq("test_token")
  end

end