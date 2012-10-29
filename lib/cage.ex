defmodule Cage do
  @type connection :: any
  def start do
    :ok = :application.start(:cage)
  end
end
