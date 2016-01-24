defmodule ExHeos do
  use Application
  use Supervisor
  alias ExHeos.Core
  alias ExHeos.Core.Module.Supervisor, as: ModuleSupervisor

  def start(_, _) do
    require Logger

    Logger.log :debug, "Starting ExHeos!"

    :pg2.start()
    :pg2.create(:modules)

    children = [
      supervisor(ModuleSupervisor, [[name: ModuleSupervisor]]),
      worker(Core, [[name: Core]])
    ]

    Logger.log :debug, "Starting Supervisors!"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
