defmodule Payday.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PaydayWeb.Telemetry,
      Payday.Repo,
      {DNSCluster, query: Application.get_env(:payday, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Payday.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Payday.Finch},
      # Start a worker by calling: Payday.Worker.start_link(arg)
      # {Payday.Worker, arg},
      # Start to serve requests, typically the last entry
      PaydayWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Payday.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PaydayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
