defmodule ExHeos.Core.Module.Supervisor do
  use Supervisor
  alias ExHeos.Core.Module.Builtin

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    require Logger

    modules = [Builtin | Application.get_env(:ex_heos, :modules)]
    children = for module <- modules do
      worker(module, [])
    end

    Logger.log :debug, "Starting modules!"

    supervise(children, strategy: :one_for_one)
  end
end
