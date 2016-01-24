defmodule ExHeos.Core do
  use GenServer
  alias ExHeos.Util

  @port 1255

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def send(message) do
    GenServer.call(__MODULE__, {:send, message})
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
    send_to_modules(:connected)
    {:noreply, state}
  end

  def handle_info({:tcp, _, messages}, state) do
    for message <- String.split(String.rstrip(messages), "\r\n") do
      handle_message(message)
    end

    {:noreply, state}
  end

  def handle_info({:tcp_closed, _}, state) do
    {:noreply, state}
  end

  defp handle_message(message) do
    message = message |> Poison.decode!
    send_to_modules({:message, message})
  end

  defp send_to_modules(x) do
    for module <- :pg2.get_members(:modules) do
      GenServer.cast(module, x)
    end
  end
end
