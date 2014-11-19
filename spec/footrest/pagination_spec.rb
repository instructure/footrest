require_relative '../spec_helper'

describe Footrest::Pagination do

  context "on_complete" do
    it 'captures prev, next, first, last, and current page links as response headers' do
      response = {
        response_headers: {
          link: "<current_link>; rel=\"current\",<next_link>; rel=\"next\",<prev_link>; rel=\"prev\",<first_link>; rel=\"first\",<last_link>; rel=\"last\""
        }
      }

      Footrest::Pagination.new.on_complete(response)

      %w(prev next first last current).each do |page|
        expect(response["#{page}_page".to_sym]).to eq("#{page}_link")
      end
    end
  end
end