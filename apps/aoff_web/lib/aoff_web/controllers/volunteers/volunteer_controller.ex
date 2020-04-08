defmodule AOFFWeb.Volunteer.VolunteerController do
  use AOFFWeb, :controller

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, _params) do
    conn = assign(conn, :page, :volunteer)
    render(conn, "index.html")
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user && conn.assigns.current_user.volunteer do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
