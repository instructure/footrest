require 'link_header'

module Footrest
  class Pagination < Faraday::Response::Middleware
    Links = Struct.new(:first, :prev, :current, :next, :last) do
      alias_method :previous, :prev
      alias_method :prevous=, :prev=

      def last_page?
        return false unless self.current && self.last
        self.current == self.last
      end
    end

    def on_complete(response)
      if response[:response_headers]
        if link_header = response[:response_headers][:link]
          links = Links.new
          %w(prev next first last current).each do |page|
            link = find_link(link_header, page)
            response["#{page}_page".to_sym] = link
            links.public_send("#{ page }=", link)
          end
          response[:pagination_links] = links
        end
      end
    end

    def find_link(header, rel)
      link = ::LinkHeader.parse(header).links.find{ |link| link['rel'] == rel }
      link.to_a.first if link
    end
  end
end

