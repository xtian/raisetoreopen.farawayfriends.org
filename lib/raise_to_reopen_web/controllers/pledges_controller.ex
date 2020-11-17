defmodule RaiseToReopenWeb.PledgesController do
  use RaiseToReopenWeb, :controller

  alias RaiseToReopen.Pledges

  import NimbleCSV.RFC4180, only: [dump_to_stream: 1]

  @headers [
    "First Name",
    "Last Name",
    "Email",
    "Amount",
    "Created At"
  ]

  def index(conn, _params) do
    contents =
      Pledges.list_pledges()
      |> Stream.map(fn {timestamp, _, pledge} ->
        [
          pledge.first_name,
          pledge.last_name,
          pledge.email,
          pledge.amount,
          DateTime.to_iso8601(timestamp)
        ]
      end)
      |> dump_to_stream()

    stream = [@headers] |> dump_to_stream() |> Stream.concat(contents)

    conn |> put_resp_content_type("text/csv") |> send_chunked(200) |> send_stream(stream)
  end

  defp send_stream(conn, stream) do
    Enum.reduce_while(stream, conn, fn chunk, conn ->
      case chunk(conn, chunk) do
        {:ok, conn} -> {:cont, conn}
        {:error, :closed} -> {:halt, conn}
      end
    end)
  end
end
