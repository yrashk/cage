defmodule Cage.WebSocket do
  @type response :: {:text, String.t} | binary
  @type message :: binary
  defmodule Behaviour do
      use Behaviour
      defcallback init(Cage.connection) :: {:ok, any} | {:shutdown, any}
      defcallback handle_text(Cage.WebSocket.message, any) :: {:ok, any} | {:reply, Cage.WebSocket.response, any}
      defcallback handle_binary(Cage.WebSocket.message, any) :: {:ok, any} | {:reply, Cage.WebSocket.response, any}
      defcallback handle_info(any, any) :: {:ok, any} | {:reply, Cage.WebSocket.response, any}
      defcallback terminate(any, any) :: any
  end
  def __using__(_) do
    quote do
      use Cage.WebSocket.Behaviour
      def init(_conn) do
        {:ok, nil}
      end
      def handle_text(_message, state) do
        {:ok, state}
      end
      def handle_binary(_message, state) do
        {:ok, state}
      end
      def handle_info(_info, state) do
        {:ok, state}
      end
      def terminate(_reason, _state), do: :ok

      defoverridable init: 1, handle_text: 2, handle_binary: 2, handle_info: 2
    end
  end
end