defmodule ExHeos.Core.Client do
  alias ExHeos.Core

  @doc """
  Controller needs to send this command with enable=on when it comes online, or
  when it is ready to receive unsolicited responses from CLI.

  Accepts "on" or "off" for enable

  Response:

    {
      "heos": {
        "command": "system/register_for_change_events",
        "result": "success",
        "message": "enable='on_or_off'"
      }
    }
  """
  def register_for_change_events(enable) do
    command("system/register_for_change_events", %{enable: enable})
  end

  @doc """
  This command returns current user name in its message field if the user is
  currently singed in.

  Response:

    {
      "heos": {
        "command": "system/check_account",
        "result": "success",
        "message": "signed_out" or "signed_in&un=<current user name>"
      }
    }
  """
  def check_account(),do: command("system/check_account")

  @doc """
  Sign into a HEOS account

  Response:

    {
      "heos": {
        "command": "system/sign_in ",
        "result": "success",
        "message": "signed_in&un=<current user name>"
      }
    }
  """
  def sign_in(username, password) do
    command("system/sign_in", %{un: username, pw: password})
  end

  @doc """
  Sign out of a HEOS account

  Response:

    {
      "heos": {
        "command": "system/sign_out ",
        "result": "success",
        "message": "signed_out"
      }
    }
  """
  def sign_out(), do: command("system/sign_out")


  @doc """
  Get a system heart beat

  Response:

    {
      "heos": {
        "command": "system/heart_beat ",
        "result": "success"
        "message": ""
      }
    }
  """
  def heart_beat(), do: command("system/heart_beat")

  @doc """
  Get active players

  Note: The group id field (gid) is optional. The 'gid' field will only appear
  if the player is part of a group.

  Response:

    {
      "heos": {
        "command": "player/get_players",
        "result": "success",
        "message": ""
      },
      "payload": [
        {
          "name": "'player name 1'",
          "pid": "player id 1'",
          "gid": "group id'",
          "model": "'player model 1'",
          "version": "'player verison 1'"
        },
        {
          "name": "'player name 2'",
          "pid": "player id 2'",
          "gid": "group id'",
          "model": "'player model 2'",
          "version": "'player verison 2'"
        },
        ...
        {
          "name": "'player name N'",
          "pid": "player id N'",
          "gid": "group id'",
          "model": "'player model N'",
          "version": "'player verison N'"
        }
      ]
    }
  """
  def get_players(), do: command("player/get_players")

  @doc """
  Get information about a specific player

  Note: The group id field (gid) is optional. The 'gid' field will only appear
  if the player is part of a group.

  Response:

    {
      "heos": {
        "command": "player/get_player_info",
        "result": "success",
        "message": "pid='player_id'"
      },
      "payload": {
        "name": "'player name'",
        "pid": "player id'",
        "gid": "group id'",
        "model": "'player model'",
        "version": "'player verison'"
      }
    }
  """
  def get_player_info(pid), do: command("player/get_player_info", %{pid: pid})

  @doc """
  Get player state

  Response:

    {
      "heos": {
        "command": " player/get_play_state ",
        "result": "success",
        "message": "pid='player_id'&state='play_state'"
      }
    }
  """
  # @TODO Maybe rename this functions to "get_player_state" instead?
  def get_play_state(pid), do: command("player/get_play_state", %{pid: pid})


  @doc """
  Set player state

  Response:

    {
      "heos": {
        "command": " player/set_play_state ",
        "result": "success",
        "message": "pid='player_id'&state='play_state'"
      }
    }
  """
  # @TODO Maybe rename this functions to "set_player_state" instead?
  def set_play_state(pid, state) do
    command("player/set_play_state", %{pid: pid, state: state})
  end

  @doc """
  Get the now playing media on a player

  Response:

  The following response provides example when the speaker is playing a song.

  Note: For local music and DLNA servers sid will point to Local Music Source id.

    {
      "heos": {
        "command": "player/get_now_playing_media",
        "result": "success",
        "message": "pid='player_id'"
      },
      "payload": {
        "type" : "'song'",
        "song": "'song name'",
        "album": "'album name'",
        "artist": "'artist name'",
        "image_url": "'image url'",
        "mid": "'media id'",
        "qid": "'queue id'",
        "sid": source_id
      }
    }

  The following response provides example when the speaker is playing a station.

    {
      "heos": {
        "command": "player/get_now_playing_media",
        "result": "success",
        "message": "pid='player_id'"
      },
      "payload": {
        "type" : "'station'",
        "song": "'song name'",
        "station": "'station name'",
        "album": "'album name'",
        "artist": "'artist name'",
        "image_url": "'image url'",
        "mid": "'media id'",
        "qid": "'queue id'",
        "sid": source_id
      }
    }
  """
  def get_now_playing_media(pid) do
    command("player/get_now_playing_media", %{pid: pid})
  end

  @doc """
  Get player volume

  Response:

    {
      "heos": {
        "command": " player/get_volume",
        "result": "success",
        "message": "pid='player_id'&level='vol_level'"
      }
    }
  """
  def get_volume(pid), do: command("player/get_volume", %{pid: pid})

  @doc """
  Set player volume to level

  Response:

    {
      "heos": {
        "command": "player/set_volume",
        "result": "success",
        "message": "pid='player_id'&level='vol_level'"
      }
    }
  """
  def set_volume(pid, level) do
    command("player/set_volume", %{pid: pid, level: level})
  end

  @doc """
  Increase the volume by step

  Response:

    {
      "heos": {
        "command": "player/volume_up",
        "result": "success",
        "message": "pid='player_id'&step='step_level'"
      }
    }
  """
  def volume_up(pid, step \\ 5) do
    command("player/volume_up", %{pid: pid, step: step})
  end

  @doc """
  Decrease the volume by step

  Response:

    {
      "heos": {
        "command": "player/volume_down",
        "result": "success",
        "message": "pid='player_id'&step='step_level'"
      }
    }
  """
  def volume_down(pid, step \\ 5) do
    command("player/volume_down", %{pid: pid, step: step})
  end

  def get_mute(pid), do: command("player/get_mute", %{pid: pid})

  def set_mute(pid, state) do
    command("player/set_mute", %{pid: pid, state: state})
  end

  def toggle_mute(pid), do: command("player/toggle_mute", %{pid: pid})

  def get_play_mode(pid), do: command("player/get_play_mode", %{pid: pid})

  def set_play_mode(pid), do: command("player/set_play_mode", %{pid: pid})

  def get_queue(pid), do: command("player/get_queue", %{pid: pid})
  def get_queue(pid, first..last = range) do
    command("player/get_queue", %{pid: pid, range: "#{first},#{last}"})
  end

  def play_queue(pid, qid) do
    command("player/play_queue", %{pid: pid, qid: qid})
  end

  def remove_from_queue(pid, qid) when qid |> is_list do
    qid = Enum.join(qid, ",")

    command("player/remove_from_queue", %{pid: pid, qid: qid})
  end

  def remove_from_queue(pid, qid) do
    command("player/remove_from_queue", %{pid: pid, qid: qid})
  end

  def save_queue(pid, name) do
    command("player/save_queue", %{pid: pid, name: name})
  end

  def clear_queue(pid), do: command("player/clear_queue", %{pid: pid})

  def play_next(pid), do: command("player/play_next", %{pid: pid})

  def play_previous(pid), do: command("player/play_previous", %{pid: pid})

  def get_groups(), do: command("groups/get_groups")

  def get_group_info(gid), do: command("groups/get_group_info", %{gid: gid})

  def set_group(pids) when pids |> is_list do
    pids = Enum.join(pids, ",")

    command("groups/set_group", %{pid: pids})
  end

  # @TODO: Naming collision with get player volume
  def get_group_volume(gid), do: command("group/get_volume", %{gid: gid})

  # @TODO: Naming collision with set player volume
  def set_group_volume(gid, level) do
    command("group/set_volume", %{gid: gid, level: level})
  end

  # @TODO: Naming collision with player volume up
  def group_volume_up(gid, step) do
    command("group/volume_up", %{gid: gid, step: step})
  end

  # @TODO: Naming collision with player volume down
  def group_volume_down(gid, step) do
    command("group/volume_down", %{gid: gid, step: step})
  end

  def get_group_mute(gid), do: command("group/get_mute", %{gid: gid})

  def set_group_mute(gid, state) do
    command("group/set_mute", %{gid: gid, state: state})
  end

  def toggle_group_mute(gid), do: command("group/toggle_mute", %{gid: gid})

  def command(command, args \\ %{}) do
    command = "heos://" <> command

    unless Enum.empty?(args) do
      command = command <> "?" <> URI.encode_query(args)
    end

    Core.send(command)
  end
end
