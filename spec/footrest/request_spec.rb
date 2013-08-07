require 'helper'

class RequestHarness; include Footrest::Request; end

describe Footrest::Request do
  let(:request) { RequestHarness.new }
  context "join" do
    it "retains initial slash" do
      expect(request.join('/test', 'path')).to eq('/test/path')
    end

    it "combines multiple segments" do
      expect(request.join('test', 'path', 'parts')).to eq('test/path/parts')
    end

    it "respects http://" do
      expect(request.join('http://', 'path')).to eq('http://path')
    end

    it "keeps slashes within strings" do
      expect(request.join('http://', 'domain', '/path/to/something')).
        to eq('http://domain/path/to/something')
    end
  end
end