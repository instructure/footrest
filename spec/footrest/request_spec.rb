require 'helper'
require 'ostruct'

class RequestHarness
  include Footrest::Connection
  include Footrest::Request
end

describe Footrest::Request do

  let(:request) { RequestHarness.new }

  it "gets" do
    stub_request(:get, "http://domain.test/page?p=1").
      to_return(:status => 200, :body => "", :headers => {})
    request.get('http://domain.test/page', :p => 1)
  end

  it "deletes" do
    stub_request(:get, "http://domain.test/page?auth=xyz").
      to_return(:status => 200, :body => "", :headers => {})
    request.get('http://domain.test/page', :auth => 'xyz')
  end

  it "posts" do
    stub_request(:post, "http://domain.test/new_page").
      with(:body => {"password"=>"xyz", "username"=>"abc"}).
      to_return(:status => 200, :body => "", :headers => {})
    request.post('http://domain.test/new_page', :username => 'abc', :password => 'xyz')
  end

  it "puts" do
    stub_request(:put, "http://domain.test/update_page").
      with(:body => {"password"=>"zzz", "username"=>"aaa"}).
      to_return(:status => 200, :body => "", :headers => {})
    request.put('http://domain.test/update_page', :username => 'aaa', :password => 'zzz')
  end
end