defmodule RaiseToReopenWeb.PageLive do
  @moduledoc false

  use RaiseToReopenWeb, :live_view

  alias RaiseToReopen.Pledges
  alias RaiseToReopen.Pledges.Pledge

  @goal Application.compile_env(:raise_to_reopen, :pledge_goal, 20_000)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> reset_form() |> assign_pledges()}
  end

  @impl true
  def handle_event("validate", %{"pledge" => params}, socket) do
    changeset = %Pledge{} |> Pledges.change_pledge(params) |> Map.put(:action, :insert)
    pending_fill = changeset |> Ecto.Changeset.get_change(:amount, 0) |> goal_percent()

    {:noreply, assign(socket, changeset: changeset, pending_fill: pending_fill)}
  end

  def handle_event("save", %{"pledge" => params}, socket) do
    socket = clear_flash(socket)

    socket =
      case Pledges.create_pledge(params) do
        :ok ->
          socket
          |> put_flash(:info, "Thank you for your pledge!")
          |> reset_form()
          |> assign_pledges()

        {:error, changeset} ->
          socket
          |> put_flash(:error, "Please fix the errors below.")
          |> assign(changeset: changeset)
      end

    {:noreply, socket}
  end

  defp assign_pledges(socket) do
    pledges = Pledges.list_pledges()
    raised = Enum.reduce(pledges, 0, fn {_, _, p}, acc -> p.amount + acc end)

    assign(socket, filled: goal_percent(raised), pledges: Enum.take(pledges, 50), raised: raised)
  end

  defp delimit_integer(number) do
    number |> abs() |> Integer.to_charlist() |> Enum.reverse() |> delimit_integer(",", [])
  end

  defp delimit_integer([a, b, c, d | tail], ",", acc) do
    delimit_integer([d | tail], ",", [",", c, b, a | acc])
  end

  defp delimit_integer(list, _, acc) do
    Enum.reverse(list) ++ acc
  end

  defp goal_percent(amount) do
    min(amount / @goal, 1) * 100
  end

  defp reset_form(socket) do
    assign(socket, changeset: Pledges.change_pledge(%Pledge{}), pending_fill: 0)
  end
end
