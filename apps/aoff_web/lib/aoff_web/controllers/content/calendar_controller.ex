defmodule AOFFWeb.Content.CalendarController do
  use AOFFWeb, :controller

  alias AOFF.Content

  def index(conn, params) do

    {:ok, calendar} = Content.find_or_create_category("Calendar")

    conn
    |> assign(:selected_menu_item, :calendar)
    |> render("index.html", calendar: calendar)
  end

  def show(conn, %{"id" => id}) do
    case Content.get_page!("Calendar", id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      page ->
        conn
        |> assign(:selected_menu_item, :calendar)
        |> assign(:title, page.title)
        |> render("show.html", category: page.category, page: page)
    end
  end

end