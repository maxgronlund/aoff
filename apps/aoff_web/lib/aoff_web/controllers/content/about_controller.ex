defmodule AOFFWeb.Content.AboutController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Content

  def index(conn, _params) do
    categories = Content.list_categories()
    conn = assign(conn, :selected_menu_item, :about_aoff)

    {:ok, message} =
      System.find_or_create_message(
        "/info",
        "Info",
        Gettext.get_locale()
      )

    {:ok, committees} =
      System.find_or_create_message(
        "/info - committees",
        "Committees",
        Gettext.get_locale()
      )

    render(conn, "index.html",
      message: message,
      categories: categories,
      committees: committees
    )
  end

  def show(conn, %{"id" => id}) do
    case Content.get_category!(id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      category ->
        render(conn, "show.html", category: category)
    end
  end
end
