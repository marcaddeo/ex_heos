defmodule ExHeos.Player do
  alias __MODULE__
  alias ExHeos.Core.Client

  defstruct [
    ip: nil,
    lineout: nil,
    model: nil,
    name: nil,
    pid: nil,
    version: nil,
  ]

  def new(json) do
    %Player{
      ip: json["ip"],
      lineout: json["lineout"],
      model: json["model"],
      name: json["name"],
      pid: json["pid"],
      version: json["version"],
    }
  end

  def new, do: %Player{}

  def get_players, do: Client.get_players

  def info(%Player{pid: pid}), do: info(pid)
  def info(pid), do: Client.get_player_info(pid)

  def state(%Player{pid: pid}), do: state(pid)
  def state(pid), do: Client.get_play_state(pid)

  def set_state(%Player{pid: pid}, state), do: set_state(pid, state)
  def set_state(pid, state), do: Client.set_play_state(pid, state)

  def now_playing(%Player{pid: pid}, state), do: now_playing(pid)
  def now_playing(pid), do: Client.get_now_playing_media(pid)

  def volume(%Player{pid: pid}, state), do: volume(pid)
  def volume(pid), do: Client.get_volume(pid)

  def set_volume(%Player{pid: pid}, level), do: set_volume(pid, level)
  def set_volume(pid, level), do: Client.set_volume(pid, level)

  def volume_up(%Player{pid: pid}, step \\ 5), do: volume_up(pid, step)
  def volume_up(pid, step), do: Client.volume_up(pid, step)

  def volume_down(%Player{pid: pid}, step \\ 5), do: volume_down(pid, step)
  def volume_down(pid, step), do: Client.volume_down(pid, step)

  def muted?(%Player{pid: pid}), do: muted?(pid)
  def muted?(pid), do: Client.get_mute(pid)

  def mute(%Player{pid: pid}), do: mute(pid)
  def mute(pid), do: Client.set_mute(pid, "on")

  def unmute(%Player{pid: pid}), do: unmute(pid)
  def unmute(pid), do: Client.set_mute(pid, "off")

  @doc """
  Note, this doesn't have any return!
  """
  def toggle_mute(%Player{pid: pid}), do: toggle_mute(pid)
  def toggle_mute(pid), do: Client.toggle_mute(pid)

  def play_mode(%Player{pid: pid}), do: play_mode(pid)
  def play_mode(pid), do: Client.get_play_mode(pid)

  def set_play_mode(%Player{pid: pid}), do: set_play_mode(pid)
  def set_play_mode(pid), do: Client.get_play_mode(pid)

  def queue(%Player{pid: pid}, range), do: queue(pid, range)
  def queue(pid, range), do: Client.get_queue(pid, range)

  def play_queue(%Player{pid: pid}, qid), do: play_queue(pid, qid)
  def play_queue(pid, qid), do: Client.play_queue(pid, qid)

  def remove_from_queue(%Player{pid: pid}, qids) when qids |> is_list do
    remove_from_queue(pid, qids)
  end
  def remove_from_queue(pid, qids) when qids |> is_list do
    Client.remove_from_queue(pid, qids)
  end

  def save_queue(%Player{pid: pid}, name), do: save_queue(pid, name)
  def save_queue(pid, name), do: Client.save_queue(pid, name |> URI.encode)

  def clear_queue(%Player{pid: pid}), do: clear_queue(pid)
  def clear_queue(pid), do: Client.clear_queue(pid)

  def next(%Player{pid: pid}), do: next(pid)
  def next(pid), do: Client.play_next(pid)

  def previous(%Player{pid: pid}), do: previous(pid)
  def previous(pid), do: Client.play_previous(pid)
end
