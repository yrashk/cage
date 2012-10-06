defmodule Cage.Middleware.WebSocket do
  use Cage.Middleware

  def call(conn, state, opts) do
    if HTTP.handles_websocket?(conn) do
      if is_atom(opts), do: opts = [handler: opts]
      handler = opts[:handler]
      {headers, conn} = HTTP.headers(conn)
      case List.keyfind(headers, "upgrade", 0) do
        nil -> {conn, state}
        {"upgrade", "websocket"} -> 
          stop(conn, State.put(__MODULE__, handler, state))
        {"upgrade", "WebSocket"} -> 
          stop(conn, State.put(__MODULE__, handler, state))
      end
    end
  end
end