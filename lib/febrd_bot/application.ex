defmodule FebrdBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FebrdBotWeb.Telemetry,
      FebrdBot.Repo,
      {DNSCluster, query: Application.get_env(:febrd_bot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FebrdBot.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FebrdBot.Finch},
      # Start a worker by calling: FebrdBot.Worker.start_link(arg)
      # {FebrdBot.Worker, arg},
      # Start to serve requests, typically the last entry
      FebrdBotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FebrdBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FebrdBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
