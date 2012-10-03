defmodule Cage.Middleware.Head do
  use Cage.Middleware

  def call(conn, state, _opts) do
    case HTTP.method(conn) do
      {"HEAD", conn}  -> 
        {HTTP.method(conn, "GET"), State.put(:original_method, "HEAD", state)}
      _ ->
        {conn, state}
    end
  end
end