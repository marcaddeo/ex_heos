defmodule ExHeos.ExampleModule do
  use ExHeos.Module

  def handle_message({:player_list, players}, state) do
    IO.puts "Got :player_list with: #{inspect players}"
    {:noreply, state}
  end

  def handle_message({:player_info, player}, state) do
    IO.puts "Got :player_info with: #{inspect player}"
    {:noreply, state}
  end

  def handle_message({:player_state, {pid, play_state}}, state) do
    IO.puts "Got :player_state for #{pid}: #{play_state}"
    {:noreply, state}
  end
end
