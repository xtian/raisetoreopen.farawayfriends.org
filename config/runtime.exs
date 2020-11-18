# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

if config_env() == :prod do
  config :raise_to_reopen, RaiseToReopenWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

  config :raise_to_reopen,
    admin_password: System.fetch_env!("ADMIN_PASSWORD"),
    data_directory: System.get_env("DATA_DIRECTORY", "/app/data/")
end
