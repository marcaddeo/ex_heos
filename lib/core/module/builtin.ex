defmodule ExHeos.Core.Module.Builtin do
  use ExHeos.Module, "builtin"
  alias ExHeos.Core.Client

  def handle_message(:connected, state) do
    require Logger
    Logger.log :debug, "Enabling change events!"

    Client.register_for_change_events("on")

    {:noreply, state}
  end

  def handle_message({:message, %{"heos" => %{"command" => "event/" <> _}}}, state) do
    {:noreply, state}
  end

  def handle_message({:message, message}, state) do
    IO.inspect message

    {:noreply, state}
  end
end
