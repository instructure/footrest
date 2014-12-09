require 'spec_helper'

module Footrest
  describe Pagination do

    describe "#on_complete" do
      let(:response) {
        {
          response_headers: {
            link: "<current_link>; rel=\"current\",<next_link>; rel=\"next\",<prev_link>; rel=\"prev\",<first_link>; rel=\"first\",<last_link>; rel=\"last\""
          }
        }
      }

      before do
        Pagination.new.on_complete(response)
      end

      it 'captures prev, next, first, last, and current page links as response headers' do
        %w(prev next first last current).each do |page|
          expect(response["#{page}_page".to_sym]).to eq("#{page}_link")
        end
      end

      it 'must capture the pagination links in an object at the pagination_links key' do
        expect(response[:pagination_links]).to be_a Pagination::Links
      end

      it 'must capture all of the link types in the Links object' do
        obj = response[:pagination_links]
        %w(prev next first last current).each do |page|
          expect(obj.public_send(page)).to eq("#{page}_link")
        end
      end
    end
  end
end
