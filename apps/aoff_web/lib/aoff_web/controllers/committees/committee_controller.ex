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
    prefix = conn.assigns.prefix

    committees =
      public_committees(prefix)
      |> member_committees(prefix, user)
      |> volunteer_committees(prefix, user)
      |> committee_member_committees(prefix, user)

    render(conn, "index.html", committees: committees)
  end

  defp public_committees(prefix) do
    Committees.list_committees(prefix, :public)
  end

  defp member_committees(committees, prefix, user) do
    if user do
      Enum.uniq(committees ++ Committees.list_committees(prefix, :member))
    else
      committees
    end
  end

  defp volunteer_committees(committees, prefix, user) do
    if user && user.volunteer do
      Enum.uniq(committees ++ Committees.list_committees(prefix, :volunteer))
    else
      committees
    end
  end

  defp committee_member_committees(committees, prefix, user) do
    if user do
      Enum.uniq(committees ++ Committees.list_committees(prefix, user.id))
    else
      committees
    end
  end

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    if committee = Committees.get_committee!(prefix, id) do
      conn = assign(conn, :selected_menu_item, :about_aoff)

      {:ok, committees_text} =
        System.find_or_create_message(
          prefix,
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
