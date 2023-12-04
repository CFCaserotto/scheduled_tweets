require "net/http"
require "uri"
require_relative "authenticator"
require_relative "cgi"
require_relative "version"

module X
  class RequestBuilder
    DEFAULT_HEADERS = {
      "Content-Type" => "application/json; charset=utf-8",
      "User-Agent" => "X-Client/#{VERSION} #{RUBY_ENGINE}/#{RUBY_VERSION} (#{RUBY_PLATFORM})"
    }.freeze
    HTTP_METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }.freeze

    def build(http_method:, uri:, body: nil, headers: {}, authenticator: Authenticator.new)
      request = create_request(http_method: http_method, uri: uri, body: body)
      add_headers(request: request, headers: headers)
      add_authentication(request: request, authenticator: authenticator)
      request
    end

    private

    def create_request(http_method:, uri:, body:)
      http_method_class = HTTP_METHODS[http_method]

      raise ArgumentError, "Unsupported HTTP method: #{http_method}" unless http_method_class

      escaped_uri = escape_query_params(uri)
      request = http_method_class.new(escaped_uri)
      request.body = body
      request
    end

    def add_authentication(request:, authenticator:)
      authenticator.header(request).each do |key, value|
        request.add_field(key, value)
      end
    end

    def add_headers(request:, headers:)
      DEFAULT_HEADERS.merge(headers).each do |key, value|
        request.delete(key)
        request.add_field(key, value)
      end
    end

    def escape_query_params(uri)
      URI(uri).tap { |u| u.query = CGI.escape_params(URI.decode_www_form(u.query)) if u.query }
    end
  end
end