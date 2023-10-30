defmodule ServSupervisor do
  require Logger

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg)
  end

  def init(_init_arg) do
    children = [
      {MyDbServer, name: MyDbServer}
    ]

    Logger.warn("Starting my supervisor")
    Supervisor.init(children, strategy: :one_for_one)
    #Supervisor.count_children(pid)
  end
end
