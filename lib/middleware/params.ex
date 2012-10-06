defmodule Cage.Middleware.Params do
  use Cage.Middleware

  def call(conn, state, opts) do
    with_body = opts[:body] || true
    {params, conn} = Cage.HTTP.query_string_params conn
    if with_body do
      case Cage.HTTP.body_params(conn) do
        {:ok, body_params, conn} -> :ok
        _ -> :ok
      end
    else
      body_params = []
    end
    params = Keyword.from_enum(params)
    body_params = Keyword.from_enum(body_params)
    params = Keyword.merge(params, body_params)  
    state = Cage.State.put(:params, params, state)
    {conn, state}
  end

end

