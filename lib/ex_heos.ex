defmodule ExHeos do
  use Application
  use Supervisor
  alias ExHeos.Core

  def start(_, _) do
    require Logger

    children = [
      worker(Core, [[name: Core]])
    ]

    Logger.log :debug, "Starting Supervisors!"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
