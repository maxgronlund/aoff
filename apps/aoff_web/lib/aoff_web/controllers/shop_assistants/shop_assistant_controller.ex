defmodule AOFFWeb.ShopAssistant.ShopAssistantController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFFWeb.Users.Auth

  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, _params) do
    dates = Shop.list_dates(Date.utc_today())
    render(conn, "index.html", dates: dates)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.shop_assistant do
      assign(conn, :selected_menu_item, :shop)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
