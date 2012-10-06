defmodule Cage.Middleware.Mount do
  use Cage.Middleware

  def call(conn, state, opts) do
    path = opts[:path]
    case {is_record(path, Regex), HTTP.path(conn)} do
        {true, {actual_path, conn}} ->
          if Regex.match?(path, actual_path) do
            redirect(conn, state, opts)
          else
            {conn, state}
          end
        {false, {^path, conn}} ->
          redirect(conn, state, opts)
        {_, conn} ->
          {conn, state}
    end
  end

  @compile {:inline, [redirect: 3]}
  defp redirect(conn, state, opts) do
    stack = opts[:stack]
    {conn, state} = stack.run(conn, state)
    stop(conn, state)  
  end
end
