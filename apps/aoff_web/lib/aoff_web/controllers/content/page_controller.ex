defmodule AOFFWeb.Content.PageController do
  use AOFFWeb, :controller

  alias AOFF.Content

  def show(conn, %{"about_id" => category_id, "id" => id}) do
    case Content.get_page!(category_id, id, conn.assigns.prefix) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      page ->
        conn
        |> assign(:selected_menu_item, :about_aoff)
        |> assign(:title, page.title)
        |> render("show.html", category: page.category, page: page)
    end
  end
end
