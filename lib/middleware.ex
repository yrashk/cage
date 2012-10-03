defmodule Cage.Middleware do
  defmacro __using__(_) do
    quote do
        alias Cage.HTTP, as: HTTP
        alias Cage.State, as: State

        defmacro __using__(opts), do: Cage.Middleware.using(__MODULE__, opts)
    end
  end

  def using(middleware, opts) do
    quote do
       @__stack__ unquote({middleware, opts})
    end
  end

end