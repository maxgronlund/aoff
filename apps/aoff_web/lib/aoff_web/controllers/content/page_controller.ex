defmodule AOFFWeb.Content.PageController do
  use AOFFWeb, :controller

  alias AOFF.Content

  def show(conn, %{"about_id" => category_id, "id" => id}) do
    page = Content.get_page!(category_id, id)
    render(conn, "show.html", category: page.category, page: page)
  end
end
