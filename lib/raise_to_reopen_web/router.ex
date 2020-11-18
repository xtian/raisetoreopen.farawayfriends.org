defmodule RaiseToReopenWeb.Router do
  use RaiseToReopenWeb, :router

  alias Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RaiseToReopenWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :basic_auth
  end

  scope "/", RaiseToReopenWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/admin", RaiseToReopenWeb do
    import Phoenix.LiveDashboard.Router

    pipe_through :browser
    pipe_through :admin

    live "/", AdminLive, :index
    live_dashboard "/dashboard", metrics: RaiseToReopenWeb.Telemetry

    get "/export", PledgesController, :index
  end

  get "/ping.txt", RaiseToReopenWeb.PingController, :index

  if Mix.env() in [:dev, :test] do
    def basic_auth(conn, _opts) do
      BasicAuth.basic_auth(conn, username: "admin", password: "pw")
    end
  else
    def basic_auth(conn, _opts) do
      BasicAuth.basic_auth(conn, username: "admin", password: System.fetch_env!("ADMIN_PASSWORD"))
    end
  end
end
