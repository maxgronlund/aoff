defmodule AOFFWeb.Committees.CommitteeController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Chats
  alias AOFF.System

  # alias AOFFWeb.Users.Auth
  # plug Auth
  # plug :authenticate when action in [:show]

  def index(conn, _params) do
    conn = assign(conn, :selected_menu_item, :about_aoff)
    committees = Committees.list_committees()
    render(conn, "index.html", committees: committees)
  end

  def show(conn, %{"id" => id}) do
    if committee = Committees.get_committee!(id) do
      conn = assign(conn, :selected_menu_item, :about_aoff)
      messages = Chats.list_messages(id)

      {:ok, committees_text} =
        System.find_or_create_message(
          "/info - committees",
          "Committees",
          Gettext.get_locale()
        )

      render(conn, "show.html",
        committee: committee,
        messages: messages,
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
