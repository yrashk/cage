defmodule Cage.Client.Body do
  use Cage.Middleware

  def call(conn, state, _opts) do
    {_body, conn} = HTTP.Client.response_body(conn)
    {conn, state}
  end
end