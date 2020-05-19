defmodule AOFFWeb.Committees.CommitteeController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Committees.Committee
  alias AOFF.Chats
  alias AOFF.System

  # alias AOFFWeb.Users.Auth
  # plug Auth
  # plug :authenticate when action in [:show]

  def index(conn, _params) do
    conn = assign(conn, :page, :about_aoff)
    committees = Committees.list_committees()
    render(conn, "index.html", committees: committees)
  end

  def show(conn, %{"id" => id}) do
    committee = Committees.get_committee!(id)
    conn = assign(conn, :page, :about_aoff)
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
  end
end
