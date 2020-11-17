# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :raise_to_reopen, RaiseToReopenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0vN2qIVCN2OHPGSZqEGcNy/2d2TTTSfR9RBTLNZiU2FwRf+mPyyna8D4075znz2k",
  render_errors: [view: RaiseToReopenWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RaiseToReopen.PubSub,
  live_view: [signing_salt: "qNhlDPqJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
