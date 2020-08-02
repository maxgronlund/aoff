defmodule AOFFWeb.Volunteer.UsersCSVController do
  use AOFFWeb, :controller

  def index(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="report.csv"])
      |> send_chunked(:ok)

    AOFF.Users.stream_users fn stream ->
      for result <- stream do
        csv_rows = NimbleCSV.RFC4180.dump_to_iodata([result])
        conn |> chunk(csv_rows)
      end
    end
    conn
  end
end
