defmodule ExHeos.Module do
  use Behaviour

  defmacro __using__(module_name) do
    quote bind_quoted: [module_name: module_name] do
      use GenServer
      import ExHeos.Module

      @module_name module_name

      Module.register_attribute __MODULE__,
        :match_docs, accumulate: true, persist: true

      def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, :ok, opts)
      end

      defoverridable start_link: 1

      def init(args) do
        require Logger

        Logger.log :debug, "Starting module #{@module_name}!"

        :pg2.join(:modules, self)

        Process.register(self, __MODULE__)

        {:ok, args}
      end

      defoverridable init: 1

      def handle_cast(message, state) do
        require Logger

        try do
          handle_message(message, state)
        rescue
          FunctionClauseError ->
            {:noreply, state}
        end
      end
    end
  end
end
