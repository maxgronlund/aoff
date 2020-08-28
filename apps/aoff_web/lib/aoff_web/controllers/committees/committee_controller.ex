defmodule AOFFWeb.Committees.CommitteeController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.System

  # alias AOFFWeb.Users.Auth
  # plug Auth
  # plug :authenticate when action in [:show]

  def index(conn, _params) do
    conn = assign(conn, :selected_menu_item, :about_aoff)
    user = conn.assigns.current_user

    committees =
      public_committees()
      |> member_committees(user)
      |> volunteer_committees(user)
      |> committee_member_committees(user)

    render(conn, "index.html", committees: committees)
  end

  defp public_committees() do
    Committees.list_committees(:public)
  end

  defp member_committees(committees, user) do
    if user do
      Enum.uniq(committees ++ Committees.list_committees(:member))
    else
      committees
    end
  end

  defp volunteer_committees(committees, user) do
    if user && user.volunteer do
      Enum.uniq(committees ++ Committees.list_committees(:volunteer))
    else
      committees
    end
  end

  defp committee_member_committees(committees, user) do
    if user do
      Enum.uniq(committees ++ Committees.list_committees(user.id))
    else
      committees
    end
  end

  def show(conn, %{"id" => id}) do
    if committee = Committees.get_committee!(id) do
      conn = assign(conn, :selected_menu_item, :about_aoff)

      {:ok, committees_text} =
        System.find_or_create_message(
          "/info - committees",
          "Committees",
          Gettext.get_locale()
        )

      render(conn, "show.html",
        committee: committee,
        committees_text: committees_text
      )
    else
      conn
      |> put_status(404)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"404")
      |> halt()
    end
  end
end
