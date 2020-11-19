defmodule AOFFWeb.Content.AboutController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Content

  plug :navbar when action in [:index, :show]

  def index(conn, _params) do
    prefix = conn.assigns.prefix
    categories = Content.list_categories(prefix)

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "/info",
        "Info",
        Gettext.get_locale()
      )

    {:ok, committees} =
      System.find_or_create_message(
        prefix,
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
    case Content.get_category!(conn.assign.prefix, id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      category ->
        conn
        |> assign(:title, category.title)
        |> render("show.html", category: category)
    end
  end

  defp navbar(conn, _opts) do
    conn
    |> assign(:selected_menu_item, :about_aoff)
    |> assign(:title, gettext("About AOFF"))
  end
end
