defmodule Cage.HTTP.Protocol do
  defmacro __using__(_) do
    quote do
      @only [Record]

      def method(http)
      def method(http, method)
      def path(http)
      def path(http, path)
      def version(http)
      def version(http, version)
      def host(http)
      def host(http, host)
      def peer(http)
      def peer(http, peer)
      def peer_addr(http)
      def peer_addr(http, peer_addr)
      def query_string(http)
      def query_string(http, query_string)
      def query_string_params(http)
      def query_string_params(http, query_string_params)
      def query_params(http)
      def fragment(http)
      def fragment(http, fragment)
      def url(http)
      def url(http, url)
      def host_url(http)
      def host_url(http, host_url)
      def headers(http)
      def headers(http, headers)
      def cookies(http)
      def cookies(http, cookies)
      def has_body?(http)
      def body(http)
      def body(http, body)

      def response_body(http, body)
      def response_body(http)

      def reply(http)
      def reply(http, opts)

      def chunked_reply(http)  
      def chunked_reply(http, opts)
      def chunk(http, data)

      def response_header(http, name, value)

      def handles_websocket?(http)
    end
  end
end