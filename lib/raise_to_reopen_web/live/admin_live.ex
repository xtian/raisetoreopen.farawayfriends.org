defmodule RaiseToReopenWeb.AdminLive do
  @moduledoc false

  use RaiseToReopenWeb, :live_view

  alias RaiseToReopen.Pledges

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> init_schedule_refresh() |> assign_pledges()}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-full lg:w-3/4 px-8 mx-auto text-gray-600">
      <h1 class="text-3xl font-bold my-4">Raise to Reopen Pledges Admin</h1>

      <div class="mb-4 flex justify-between">
        <p>Total pledged: $<%= @raised %></p>
        <%= link "Download CSV", to: Routes.pledges_path(@socket, :index), download: true,
          class: "bg-blue-300 text-white py-1 px-2 rounded-sm" %>
      </div>

      <table class="w-full">
        <thead>
          <tr class="text-left">
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Created</th>
            <th class="text-right">Amount</th>
            <th></th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <%= for {timestamp, id, pledge} <- @pledges do %>
            <tr class="hover:bg-gray-100">
              <td><%= pledge.first_name %></td>
              <td><%= pledge.last_name %></td>
              <td><a href="mailto:<%= pledge.email %>" class="text-blue-300 underline"><%= pledge.email %></a></td>
              <td><%= Timex.from_now(timestamp) %></td>
              <td class="text-right"><%= pledge.amount %></td>
              <td class="text-right">
                <button
                  phx-click="delete" phx-value-id="<%= id %>"
                  data-confirm="Delete this pledge for $<%= pledge.amount %>?"
                  class="bg-red text-white py-1 px-2 my-1 rounded-sm">Delete</button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Pledges.delete_pledge(id)
    {:noreply, assign_pledges(socket)}
  end

  @impl true
  def handle_info(:refresh, socket) do
    {:noreply, socket |> schedule_refresh() |> assign_pledges()}
  end

  defp assign_pledges(socket) do
    pledges = Pledges.list_pledges()
    raised = Enum.reduce(pledges, 0, fn {_, _, p}, acc -> p.amount + acc end)

    assign(socket, pledges: Enum.to_list(pledges), raised: raised)
  end

  defp init_schedule_refresh(socket) do
    if connected?(socket) do
      schedule_refresh(socket)
    else
      assign(socket, timer: nil)
    end
  end

  defp schedule_refresh(socket) do
    assign(socket, timer: Process.send_after(self(), :refresh, 1000))
  end
end
