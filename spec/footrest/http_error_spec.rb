require_relative '../spec_helper'

module Footrest
  describe HttpError do
    before do
      @client = Client.new(prefix: "http://domain.com", token: "test_token")
    end

    describe HttpError::ErrorBase, :focus do
      let(:response) { Faraday::Env.new(
        :get,
        { }.to_json,
        URI.parse('http://domain.com/api/v1/not_found'),
        Faraday::RequestOptions.new,
        {
          "Accept"=>"application/json",
          "Authorization"=>"Bearer 365~deadbeef123458792",
          "User-Agent"=>"Footrest"
        },
        Faraday::SSLOptions.new,
        nil,
        nil,
        nil,
        {"Foo-Bar" => 'baz'},
        400,
        "Bad Response", { errors: [{message: "I don't even"}] }.to_json
      ) }
      let(:error) { HttpError::ErrorBase.new(response) }

      describe '#initialize(response)' do
        it 'must include the status code in the message' do
          expect(error.message).to include '400'
        end

        it 'must include the status message for the status code in the message' do
          expect(error.message).to include 'Bad Request'
        end

        it 'must include the http method in the request method in the message' do
          expect(error.message).to include 'GET'
        end

        it 'must include the request url in the message' do
          expect(error.message).to include 'http://domain.com/api/v1/not_found'
        end

        it 'must include the parsed errors in the message' do
          expect(error.message).to include "I don't even"
        end

        it 'must include the response headers in the message' do
          expect(error.message).to include 'Foo-Bar'
        end

        it 'must include the sanitized request headers in the message' do
          expect(error.message).to include 'Bearer 365~dead...'
        end
      end

      describe '#sanitized_request_headers' do
        it 'must truncate the value for the Authorization header when it looks like a production Canvas token' do
          expect(error.sanitized_request_headers).to include 'Authorization' => 'Bearer 365~dead...'
        end

        it 'must truncate the value for the Authorization header when it looks like a generic Bearer token' do
          response.request_headers['Authorization'] = 'Bearer this-token-is-super-sekret'
          expect(error.sanitized_request_headers).to include 'Authorization' => 'Bearer this...'
        end
      end
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
end
