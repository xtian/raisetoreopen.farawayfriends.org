defmodule RaiseToReopenWeb.Router do
  use RaiseToReopenWeb, :router

  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RaiseToReopenWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :basic_auth,
      username: "admin",
      password: Application.compile_env!(:raise_to_reopen, :admin_password)
  end

  scope "/", RaiseToReopenWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/admin", RaiseToReopenWeb do
    pipe_through :browser
    pipe_through :admin

    live "/", AdminLive, :index

    get "/export", PledgesController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RaiseToReopenWeb.Telemetry
    end
  end
end
