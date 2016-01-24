defmodule ExHeos.Core.Module.Builtin do
  use ExHeos.Module, "builtin"
  alias ExHeos.Core
  require Logger

  def handle_message(:connected, state) do
    Logger.log :debug, "Enabling change events!"

    Core.send("heos://system/register_for_change_events?enable=on")

    {:noreply, state}
  end

  def handle_message({:message, message}, state) do
    Logger.log :debug, "Received message: #{message}"

    {:noreply, state}
  end
end
