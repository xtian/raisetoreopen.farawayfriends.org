defmodule RaiseToReopenWeb.PageLive do
  @moduledoc false

  use RaiseToReopenWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    """
  end
end
