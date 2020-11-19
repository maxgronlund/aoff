defmodule AOFFWeb.Purchaser.PurchaserController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFFWeb.Users.Auth

  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, _params) do
    products = Shop.list_products(conn.assigns.prefix)
    conn = assign(conn, :selected_menu_item, :purchaser)

    render(conn, "index.html", products: products)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.purchasing_manager do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
