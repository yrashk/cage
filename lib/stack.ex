defmodule Cage.Stack do
  defmacro __using__(_) do
    quote do
      Module.register_attribute __MODULE__, :__stack__

      def run(conn), do: Cage.Stack.run(conn, __MODULE__)
    end
  end

  def run(conn, module) do
    state = Cage.State.new
    units = lc {:__stack__, [unit]} inlist module.__info__(:attributes), do: unit
    Enum.reduce units, {conn, state}, fn({unit, opts}, {conn, state}) -> apply(unit, :call, [conn, state, opts]) end
  end

end