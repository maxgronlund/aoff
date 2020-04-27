defmodule AOFFWeb.Volunteer.MembershipController do
  use AOFFWeb, :controller

  alias AOFF.Shop

  def index(conn, params) do
    IO.inspect(params)

    memberships = Shop.list_memberships()
    render(conn, "index.html", memberships: memberships)
  end
end
