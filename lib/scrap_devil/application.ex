defmodule ScrapDevil.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ScrapDevilWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ScrapDevil.PubSub},
      # Start Finch
      {Finch, name: ScrapDevil.Finch},
      # Start the Endpoint (http/https)
      ScrapDevilWeb.Endpoint,
      # Start a worker by calling: ScrapDevil.Worker.start_link(arg)
      # {ScrapDevil.Worker, arg}
      ScrapDevil.Core.Runtime.Server
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScrapDevil.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScrapDevilWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
