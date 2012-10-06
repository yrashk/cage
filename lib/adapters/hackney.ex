defrecord Cage.HTTP.Hackney, 
          method: "GET",
          url: nil,
          headers: [],
          body: "",
          options: [],
          status: nil,
          response_headers: [],
          response_body: nil,
          client: nil do
  defmacro accessor(key) do
    quote do
      def unquote(key).(Cage.HTTP.Hackney[] = t) do
        Cage.HTTP.Hackney.unquote(key)(t)
      end

      def unquote(key).(Cage.HTTP.Hackney[] = t, value) do
        Cage.HTTP.Hackney.unquote(key)(value, t)
      end

      defoverridable [{unquote(key),1},{unquote(key), 2}]
    end
  end          
end

defmodule Cage.HTTP.Client.Hackney do
  defmacro __using__(_) do
    quote do
      alias Cage.HTTP.Hackney, as: T
      alias :hackney, as: R
      import Cage.HTTP.Hackney, only: [accessor: 1]      

      accessor :method
      accessor :url
      accessor :headers
      accessor :body
      accessor :status
      accessor :response_headers
      accessor :response_body

      def response_body(T[response_body: nil, client: client] = t) when client != nil do
        {:ok, body, client} = R.body(client)
        t = T.response_body(body, t)
        t = T.client(client, t)
        {body, t}
      end

      def request(T[method: m, url: url, headers: hs, body: payload, options: opts] = t) do
        case R.request(m, url, hs, payload, opts) do
          {:ok, status_code, resp_headers, client} ->
            t = T.status(status_code, t)
            t = T.response_headers(resp_headers, t)
            t = T.client(client, t)
            {:ok, t}
          {:ok, :maybe_redirect, status_code, resp_headers, client} ->
            t = T.status(status_code, t)
            t = T.response_headers(resp_headers, t)
            t = T.client(client, t)
            {:ok, t}
          {:error, _} = error ->
            error
        end
      end

    end
  end
end
