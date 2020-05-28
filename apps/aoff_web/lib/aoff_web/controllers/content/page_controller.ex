defmodule AOFFWeb.Content.PageController do
  use AOFFWeb, :controller

  alias AOFF.Content

  def show(conn, %{"about_id" => category_id, "id" => id}) do
    case Content.get_page!(category_id, id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Language updated"))
        |> redirect(to: Routes.about_path(conn, :index))

      page ->
        render(conn, "show.html", category: page.category, page: page)
    end
  end
end
