defmodule Cage.WebSocket do
  defmodule Behaviour do
      use Behaviour
      defcallback init(conn)
      defcallback handle_text(message, state)
      defcallback handle_binary(message, state)
      defcallback handle_info(info, state)
      defcallback terminate(reason, state)
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