defmodule BirdieMachine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BirdieMachineWeb.Telemetry,
      BirdieMachine.Repo,
      {DNSCluster, query: Application.get_env(:birdie_machine, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BirdieMachine.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BirdieMachine.Finch},
      # Start a worker by calling: BirdieMachine.Worker.start_link(arg)
      # {BirdieMachine.Worker, arg},
      # Start to serve requests, typically the last entry
      BirdieMachineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BirdieMachine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BirdieMachineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
