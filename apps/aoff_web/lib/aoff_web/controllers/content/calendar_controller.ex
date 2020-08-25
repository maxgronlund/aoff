defmodule AOFFWeb.Content.CalendarController do
  use AOFFWeb, :controller

  alias AOFF.Content

  def index(conn, params) do

    IO.inspect calendar = Content.find_or_create_category("Calendar")


    conn
    |> assign(:selected_menu_item, :calendar)
    |> render("index.html", calendar: calendar)
  end

  def show(conn, params) do
    render(conn, "show.html", event: "fo")
  end

end