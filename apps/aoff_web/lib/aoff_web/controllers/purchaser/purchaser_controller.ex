defmodule AOFFWeb.Purchaser.PurchaserController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.Shop.Product
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, _params) do
    products = Shop.list_products()
    conn = assign(conn, :page, :purchaser)

    render(conn, "index.html", products: products)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user && conn.assigns.current_user.purchasing_manager do
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
