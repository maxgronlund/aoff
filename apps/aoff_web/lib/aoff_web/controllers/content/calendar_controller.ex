defmodule AOFFWeb.Content.CalendarController do
  use AOFFWeb, :controller

  alias AOFF.Content
  alias AOFF.System

  def index(conn, params) do
    {:ok, calendar} = Content.find_or_create_category("Calendar")

    {:ok, message} =
      System.find_or_create_message(
        "Calendar",
        "Calendar",
        Gettext.get_locale()
      )

    conn
    |> assign(:selected_menu_item, :calendar)
    |> render("index.html", calendar: calendar, message: message)
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
