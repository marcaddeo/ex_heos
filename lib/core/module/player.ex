defmodule ExHeos.Core.Module.Player do
  use ExHeos.Module, "player"
  alias ExHeos.Core
  alias ExHeos.Player

  @doc """
  Watch for incoming `player/get_players` messages to parse and broadcast to
  other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_players",
          "message" => "",
          "result" => "success",
        },
        "payload" => payload,
      },
    }, state
  ) do
    players =
      payload
      |> Enum.map(fn (payload) ->
        payload |> Player.new
      end)

    Core.broadcast({:player_list, players})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_player_info` messages to parse and broadcast to
  other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_player_info",
          "result" => "success",
          "message" => "pid=" <> pid,
        },
        "payload" => payload,
      },
    }, state
  ) do
    Core.broadcast({:player_info, {pid, Player.new(payload)}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_play_state` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_play_state",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "state" => play_state} = URI.decode_query(message)
    Core.broadcast({:player_state, {pid, play_state}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/set_play_state` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/set_play_state",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "state" => play_state} = URI.decode_query(message)
    Core.broadcast({:player_state, {pid, play_state}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_now_playing_media` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_now_playing_media",
          "result" => "success",
          "message" => "pid=" <> pid,
        }
      },
      "payload" => payload,
    }, state
  ) do

    # @TODO: Convert the payload into something more useful
    Core.broadcast({:now_playing, {pid, payload}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_volume` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_volume",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "level" => level} = URI.decode_query(message)

    Core.broadcast({:player_volume, {pid, level}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/set_volume` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/set_volume",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "level" => level} = URI.decode_query(message)

    Core.broadcast({:player_volume, {pid, level}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/volume_up` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/volume_up",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "step" => step} = URI.decode_query(message)

    Core.broadcast({:player_volume_up, {pid, step}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/volume_down` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/volume_down",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "step" => step} = URI.decode_query(message)

    Core.broadcast({:player_volume_down, {pid, step}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_mute` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_mute",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "state" => mute} = URI.decode_query(message)

    muted? = case mute do
      "on" -> true,
      _ -> false
    end

    Core.broadcast({:player_muted?, {pid, muted?}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/set_mute` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/set_mute",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "state" => mute} = URI.decode_query(message)

    muted? = case mute do
      "on" -> true,
      _ -> false
    end

    Core.broadcast({:player_muted?, {pid, muted?}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_play_mode` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_play_mode",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid} = data = URI.decode_query(message)

    Core.broadcast({:player_mode, {pid, data}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/set_play_mode` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/set_play_mode",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid} = data = URI.decode_query(message)

    Core.broadcast({:player_mode, {pid, data}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/get_queue` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/get_queue",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
      "payload" => payload,
    }, state
  ) do
    %{"pid" => pid} = data = URI.decode_query(message)

    # @TODO: convert payload to something useful
    Core.broadcast({:player_queue, {pid, payload}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/play_queue` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/play_queue",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "qid" => qid} = data = URI.decode_query(message)

    Core.broadcast({:player_play_queue, {pid, qid}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/remove_from_queue` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/remove_from_queue",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "qid" => qid} = data = URI.decode_query(message)

    qids = qid |> String.split(",")

    Core.broadcast({:player_remove_from_queue, {pid, qids}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/save_queue` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/save_queue",
          "result" => "success",
          "message" => "pid=" <> _ = message,
        }
      },
    }, state
  ) do
    %{"pid" => pid, "name" => name} = data = URI.decode_query(message)

    Core.broadcast({:player_save_queue, {pid, name}})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/clear_queue` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/clear_queue",
          "result" => "success",
          "message" => "pid=" <> pid,
        }
      },
    }, state
  ) do
    Core.broadcast({:player_clear_queue, pid})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/play_next` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/play_next",
          "result" => "success",
          "message" => "pid=" <> pid,
        }
      },
    }, state
  ) do
    Core.broadcast({:player_next, pid})

    {:noreply, state}
  end

  @doc """
  Watch for incoming `player/play_previous` messages to parse and
  broadcast to other modules.
  """
  def handle_message(
    {
      :message,
      %{"heos" => %{
          "command" => "player/play_previous",
          "result" => "success",
          "message" => "pid=" <> pid,
        }
      },
    }, state
  ) do
    Core.broadcast({:player_previous, pid})

    {:noreply, state}
  end
end
