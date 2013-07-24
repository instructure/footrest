
require 'footrest'
require 'rspec'
require 'webmock/rspec'
require 'json'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture(file)
  File.new(File.join(File.expand_path("../fixtures", __FILE__), file))
end

def stub_get(client, url)
  stub_request(:get, "#{client.domain}#{url}")
end

def stub_post(client, url)
  stub_request(:post, "#{client.domain}#{url}")
end

def stub_put(client, url)
  stub_request(:put, "#{client.domain}#{url}")
end

def stub_delete(client, url)
  stub_request(:delete, "#{client.domain}#{url}")
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

