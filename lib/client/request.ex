defmodule Cage.Client.Request do
  use Cage.Middleware

  def call(conn, state, _opts) do
    case HTTP.Client.request(conn) do
      {:ok, conn} -> {conn, state}
      {:error, _} = error -> halt(error, conn, state)
    end
  end
end