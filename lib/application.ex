defmodule MyApp do
  require Logger
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      #   # Starts a worker by calling: Chapter1.Worker.start_link(arg)
      #   # {Chapter1.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: Server.Router, options: [port: 4001]},
      #
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Logger.warn("STARTING My application")
    Logger.warn("HELLOOO")
    opts = [strategy: :one_for_one, name: Chapter1.Supervisor]
    Supervisor.start_link(children, opts)
    ServSupervisor.start_link([])
  end
end
