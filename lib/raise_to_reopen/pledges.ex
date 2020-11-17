defmodule RaiseToReopen.Pledges do
  @moduledoc false

  alias __MODULE__.Pledge

  @pledges_table :pledges
  @table_options [
    :ordered_set,
    :named_table,
    :public,
    {:read_concurrency, true}
  ]

  def list_pledges do
    @pledges_table
    |> :ets.tab2list()
    |> Stream.map(fn {timestamp, map} ->
      {
        Timex.from_unix(timestamp * -1),
        struct(Pledge, map)
      }
    end)
  end

  def create_pledge(params) do
    result = %Pledge{} |> Pledge.changeset(params) |> Ecto.Changeset.apply_action(:insert)

    with {:ok, pledge} <- result do
      current_time = :os.system_time(:seconds)
      :ets.insert(@pledges_table, {current_time * -1, Map.from_struct(pledge)})
      :ok
    end
  end

  def change_pledge(struct, params \\ %{}) do
    Pledge.changeset(struct, params)
  end

  def start_persistent_ets do
    pledges_file =
      Application.get_env(:raise_to_reopen, :pledges_table_file, "/opt/cache/pledges.tab")

    _ = PersistentEts.new(@pledges_table, pledges_file, @table_options)

    :ok
  end
end
