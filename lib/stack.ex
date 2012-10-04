defmodule Cage.Stack do
  defmacro __using__(_) do
    quote do
      Module.register_attribute __MODULE__, :__stack__

      def run(conn, state // nil), do: Cage.Stack.run(conn, state, __MODULE__)
    end
  end

  defexception StopExecution, message: nil, conn: nil, state: nil

  def run(conn, state, module) do
    state = state || Cage.State.new
    units = lc {:__stack__, [unit]} inlist module.__info__(:attributes), do: unit
    run_units(conn, state, units)
  end

  defp run_units(conn, state, []), do: {conn, state}
  defp run_units(conn, state, [{unit, opts}|rest]) do
    {conn, state} = apply(unit, :call, [conn, state, opts])
    run_units(conn, state, rest)
  rescue StopExecution[conn: conn, state: state] ->
      {conn, state}
  end

end