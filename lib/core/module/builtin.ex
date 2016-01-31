defmodule ExHeos.Core.Module.Builtin do
  use ExHeos.Module, "builtin"
  alias ExHeos.Core.Player
  alias ExHeos.Core.Client
  alias ExHeos.Core.Player.Server, as: PlayerServer

  def handle_message(:connected, state) do
    require Logger
    Logger.log :debug, "Enabling change events!"

    Client.register_for_change_events("on")

    {:noreply, state}
  end

  def handle_message({:message, %{"heos" => %{"command" => "system/register_for_change_events"}}}, state) do
    Client.get_players()
    {:noreply, state}
  end

  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_players",
          "message" => "",
          "result" => "success",
        },
        "payload" => payload
      },
    }, state
  ) do
    payload
    |> Enum.map(fn (payload) ->
      %Player{
        ip: payload["ip"],
        lineout: payload["lineout"],
        model: payload["model"],
        name: payload["name"],
        pid: payload["pid"],
        version: payload["version"],
      }
    end)
    |> PlayerServer.set_players

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
