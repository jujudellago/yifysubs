module Yifysubs
  class Response::HTML < Response

    dependency 'nokogiri'

    define_parser do |body|
      Nokogiri::HTML body
    end

    def parse(body)
      case body
      when String
        self.class.parser.call body
      else
        body
      end
    end

  end # Response::HTML
end # Yifysubs
