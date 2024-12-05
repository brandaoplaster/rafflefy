defmodule Rafflefy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RafflefyWeb.Telemetry,
      Rafflefy.Repo,
      {DNSCluster, query: Application.get_env(:rafflefy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rafflefy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Rafflefy.Finch},
      # Start a worker by calling: Rafflefy.Worker.start_link(arg)
      # {Rafflefy.Worker, arg},
      # Start to serve requests, typically the last entry
      RafflefyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rafflefy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RafflefyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
