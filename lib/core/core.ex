defmodule ExHeos.Core do
  use GenServer
  alias ExHeos.Util

  @port 1255

  def start_link(opts \\ []) do
    {:ok, pid } = GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    require Logger

    # Find the first HEOS device
    {:ok, [{_, %{host: host}} = device | _]} = Util.discover
    host = host |> String.to_char_list

    Logger.log :debug, "Connecting to #{host}:#{@port}"
    {:ok, socket} = :gen_tcp.connect(host, @port, [:binary, active: true])
    Logger.log :debug, "Connected."

    send self, :init

    {:ok, %{socket: socket}}
  end

  def handle_call({:send, message}, _, %{socket: socket} = state) do
    require Logger

    Logger.log :debug, "Sending #{message}"

    :gen_tcp.send(socket, message)

    {:reply, :ok, state}
  end

  def handle_info(:init, state) do
    {:noreply, state}
  end

  def handle_info({:tcp, _, messages}, state) do
    for msg <- String.split(String.rstrip(messages), "\r\n") do
      handle_message(msg)
    end

    {:noreply, state}
  end

  def handle_info({:tcp_closed, _}, state) do
    {:noreply, state}
  end

  defp handle_message(message) do
    require Logger

    Logger.log :debug, "Received #{message}"
  end
end
