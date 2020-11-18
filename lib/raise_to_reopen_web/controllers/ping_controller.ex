defmodule RaiseToReopenWeb.PingController do
  use RaiseToReopenWeb, :controller

  def index(conn, _params) do
    text(conn, "ok")
  end
end
