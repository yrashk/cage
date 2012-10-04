defmodule Cage.Middleware.Stack do
  use Cage.Middleware

  def call(conn, state, opts) do
    if is_atom(opts), do: opts = [stack: opts]
    stack = opts[:stack]
    {conn, state} = stack.run(conn, state)
    if opts[:stop] == true do
      stop(conn, state)
    else
      {conn, state}
    end
  end
end