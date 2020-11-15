defmodule RaiseToReopen.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      RaiseToReopenWeb.Telemetry,
      {Phoenix.PubSub, name: RaiseToReopen.PubSub},
      RaiseToReopenWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: RaiseToReopen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RaiseToReopenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
