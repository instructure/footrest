require_relative '../spec_helper'

describe Footrest::HttpError do
  before do
    @client = Footrest::Client.new(prefix: "http://domain.com", token: "test_token")
  end

  it "raises a bad request error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 400)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::BadRequest => e
      expect(e.status).to eq(400)
    end
  end

  it "raises a unauthorized error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 401)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::Unauthorized => e
      expect(e.status).to eq(401)
    end
  end

  it "raises a forbidden error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 403)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::Forbidden => e
      expect(e.status).to eq(403)
    end
  end


  it "raises a not found error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 404)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::NotFound => e
      expect(e.status).to eq(404)
    end
  end

  it "raises a method not found allowed" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 405)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::MethodNotAllowed => e
      expect(e.status).to eq(405)
    end
  end

  it "raises a internal server error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 500)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::InternalServerError => e
      expect(e.status).to eq(500)
    end
  end

  it "raises a not implemented error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 501)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::NotImplemented => e
      expect(e.status).to eq(501)
    end
  end

  it "raises a bad gateway error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 502)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::BadGateway => e
      expect(e.status).to eq(502)
    end
  end

  it "raises a Server Unavailible error" do
    stub_request(:get, "http://domain.com/api/v1/not_found").to_return(:status => 503)

    begin
      @client.get "/api/v1/not_found"
    rescue Footrest::HttpError::ServiceUnavailable => e
      expect(e.status).to eq(503)
    end
  end

end