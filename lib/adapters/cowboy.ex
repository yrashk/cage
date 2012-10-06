defrecord Cage.HTTP.Cowboy, req: nil, subst: [] do
  defoverridable new: 1

  def new(opts) do
    if is_record(opts, :http_req) do
      super(req: opts)
    else 
      super(opts)
    end
  end

  def substitute(key, value, rec) do
    subst(Keyword.put(subst(rec), key, value), rec)
  end

  defmacro unless_substituted(key, rec, [do: block]) do
    quote do
      if (value = Cage.HTTP.Cowboy.subst(unquote(rec))[unquote(key)]) do
        {value, unquote(rec)}
      else
        unquote(block)
      end
    end
  end

  defmacro accessor(key, opts // []) do
    as = opts[:as] || key
    quote do
      def unquote(key).(Cage.HTTP.Cowboy[req: req] = t) do
        unless_substituted(unquote(key), t) do
          case :cowboy_req.unquote(as)(req) do
            {value, req} ->
              {value, Cage.HTTP.Cowboy.req(req, t)}
            {:ok, value, req} ->
              {:ok, value, Cage.HTTP.Cowboy.req(req, t)}
            other -> other
          end
        end
      end

      def unquote(key).(Cage.HTTP.Cowboy[] = t, value) do
        Cage.HTTP.Cowboy.substitute(unquote(key), value, t)
      end
    end
  end

  defmacro __using__(opts) do
    quote do
      use Cage.HTTP.Cowboy.Implementation, unquote(opts)
    end
  end

end

defmodule Cage.HTTP.Cowboy.Handler do
  def init(_, req, opts), do: {:ok, req, opts}

  def handle(req, opts) do
    {conn, _state} = opts[:stack].run(Cage.HTTP.Cowboy.new(req))
    req = Cage.HTTP.Cowboy.req(conn)
    {:ok, req, opts}
  end

  def terminate(_req, _state), do: :ok
end

defmodule Cage.HTTP.Cowboy.Implementation do
  defmacro __using__(_) do
    quote do
      alias Cage.HTTP.Cowboy, as: T
      alias :cowboy_req, as: R
      import Cage.HTTP.Cowboy, only: [unless_substituted: 3, accessor: 1, accessor: 2]

      accessor :method
      accessor :path
      accessor :version
      accessor :host
      accessor :peer
      accessor :peer_addr
      accessor :query_string, as: :qs
      accessor :query_string_params, as: :qs_vals
      accessor :body_params, as: :body_qs
      accessor :fragment
      accessor :url
      accessor :host_url
      accessor :headers
      accessor :cookies
      accessor :has_body?, as: :has_body
      accessor :body

      def response_header(T[req: req] = t, name, value) do
        req = R.set_resp_header(name, value, req)
        T.req(req, t)
      end

      def response_body(T[] = t) do
        {T.subst(t)[:response_body], t}
      end

      def response_body(T[req: req] = t, body) do
        req = R.set_resp_body(body, req)    
        T.req(req, T.substitute(:response_body, body, t))
      end

      def reply(T[req: req] = t, opts // []) do
        {:ok, req} = R.reply(opts[:status] || 200, opts[:headers] || [], opts[:body] || T.subst(t)[:response_body] || "", req)
        {:ok, T.req(req, t)}
      end

      def chunked_reply(T[req: req] = t, opts // []) do
        {:ok, req} = R.chunked_reply(opts[:status] || 200, opts[:headers] || [], req)
        {:ok, T.req(req, t)}
      end  

      def chunk(T[req: req] = t, data) do
        result = R.chunk(data, req)
        {result, t}
      end
    end
  end
end