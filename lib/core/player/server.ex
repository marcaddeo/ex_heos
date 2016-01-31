defmodule ExHeos.Core.Player.Server do
  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def set_players(players) do
    Agent.cast(__MODULE__, fn _ -> players end)
  end

  def get_players() do
    Agent.get(__MODULE__, fn players -> players end)
  end
end
