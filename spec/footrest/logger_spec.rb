require_relative '../spec_helper'
require 'logger'
require 'stringio'

describe "Footrest request logging" do
  let(:io) { StringIO.new }
  let(:client) do
    Footrest::Client.new(
      prefix: "http://domain.test",
      token: "s3cr3t~deadbeef",
      logger: ::Logger.new(io)
    )
  end

  before do
    stub_request(:get, "http://domain.test/page").
      to_return(status: 200, body: "{}", headers: { content_type: "application/json" })
  end

  it "redacts the Authorization bearer token from the logs" do
    client.get("/page")

    expect(io.string).to include("Authorization: [FILTERED]")
    expect(io.string).not_to include("s3cr3t~deadbeef")
  end
end
