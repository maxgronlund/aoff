defmodule AOFFWeb.Users.WelcomeController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(conn, %{"user_id" => user_id}) do
    prefix = conn.assigns.prefix
    user = Users.get_user(prefix, user_id)

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "Welcome to AOFF",
        "Welcome to AOFF",
        Gettext.get_locale()
      )

    render(conn, "index.html", user: user, message: message)
  end
end
