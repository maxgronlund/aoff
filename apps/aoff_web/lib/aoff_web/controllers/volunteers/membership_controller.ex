defmodule AOFFWeb.Volunteer.MembershipController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, params) do
    memberships = Shop.list_memberships()
    render(conn, "index.html", memberships: memberships)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :page, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
