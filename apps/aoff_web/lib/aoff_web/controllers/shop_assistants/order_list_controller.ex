defmodule AOFFWeb.ShopAssistant.OrderListController do
  use AOFFWeb, :controller
  alias AOFF.Shop

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    date = Shop.get_date!(prefix, id)
    products = Shop.paid_orders_list(prefix, date.id)

    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("Order list"))
    |> render("show.html", date: date, products: products)
  end
end
