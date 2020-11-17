defmodule RaiseToReopenWeb.PageLiveTest do
  use RaiseToReopenWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Raise to Reopen"
    assert render(page_live) =~ "Raise to Reopen"
  end
end
