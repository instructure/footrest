require 'helper'

describe Footrest::Client do

  it "sets the domain" do
    client = Footrest::Client.new(domain:"http://domain.com")
    expect(client.options[:domain]).to eq("http://domain.com")

  end

  it "sets the authtoken" do
    client = Footrest::Client.new(token:"test_token")
    expect(client.options[:token]).to eq("test_token")
  end

end