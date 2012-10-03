defmodule Cage do
  def start do
    :ok = :application.start(:cage)
  end
end
