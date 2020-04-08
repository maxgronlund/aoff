defmodule AOFFWeb.Shop.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.System

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :shop)
    date = Shop.get_date!(id)
    products = Shop.list_products(:for_sale)

    unless conn.assigns.valid_member do
      {:ok, expired_message } = System.find_or_create_message("/shop/ - expired", Gettext.get_locale())
      {:ok, login_message } = System.find_or_create_message("/shop/ - login", Gettext.get_locale())
      render(
        conn,
        "show.html",
        expired_message: expired_message,
        login_message: login_message,
        date: date,
        products: products
      )
    else
      render(conn, "show.html", date: date, products: products)
    end
  end
end
