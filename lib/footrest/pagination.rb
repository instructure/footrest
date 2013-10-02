require 'link_header'

module Footrest
  class Pagination < Faraday::Response::Middleware
    def on_complete(response)
      if response[:response_headers]
        if link = response[:response_headers][:link]
          response[:next_page] = find_link(link, "next")
          response[:first_page] = find_link(link, "first")
        end
      end
    end

    def find_link(header, rel)
      link = ::LinkHeader.parse(header).links.find{ |link| link['rel'] == rel }
      link.to_a.first if link
    end
  end
end

