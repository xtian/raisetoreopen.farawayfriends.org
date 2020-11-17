use Mix.Config

config :raise_to_reopen,
  admin_password: "pw",
  pledges_table_file: Path.join(__DIR__, "../test/fixtures/pledges.tab")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :raise_to_reopen, RaiseToReopenWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
