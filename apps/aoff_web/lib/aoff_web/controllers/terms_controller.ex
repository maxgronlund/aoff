defmodule AOFFWeb.TermsController do
  use AOFFWeb, :controller
  alias AOFF.System

  def index(conn, _params) do
    {:ok, message} =
      System.find_or_create_message(
        conn.assigns.prefix,
        "/terms",
        "Terms and condition",
        Gettext.get_locale()
      )

    render(conn, :index, message: message)
  end
end
