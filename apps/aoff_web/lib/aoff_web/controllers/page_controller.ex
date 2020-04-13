defmodule AOFFWeb.PageController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Shop

  def index(conn, _params) do



    # if user = conn.assigns.current_user do
    #   redirect(conn, to: Routes.user_path(conn, :show, user))
    # else
      {:ok, message } = System.find_or_create_message("/", Gettext.get_locale())
      date = Shop.get_next_date(Date.utc_today())
      products = Shop.get_products_for_landing_page()
      conn = assign(conn, :backdrop, :show)
      conn = assign(conn, :page, :home)
      render(conn, "index.html", products: products, date: date, message: message)
    # end

  end
end
