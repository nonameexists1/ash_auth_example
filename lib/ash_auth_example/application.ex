defmodule AshAuthExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AshAuthExampleWeb.Telemetry,
      AshAuthExample.Repo,
      {DNSCluster, query: Application.get_env(:ash_auth_example, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshAuthExample.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AshAuthExample.Finch},
      # Start a worker by calling: AshAuthExample.Worker.start_link(arg)
      # {AshAuthExample.Worker, arg},
      # Start to serve requests, typically the last entry
      AshAuthExampleWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :ash_auth_example]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshAuthExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshAuthExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
