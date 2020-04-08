defmodule AOFFWeb.Purchaser.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  # alias AOFF.Shop.Date
  alias AOFF.Users

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show]


  def index(conn, _params) do
    dates = Shop.list_dates(Date.utc_today())
    render(conn, "index.html", dates: dates)
  end


  def show(conn, %{"id" => id}) do
    date = Shop.get_date!(id)
    products = Shop.get_shopping_list(date.id)

    render(conn,"show.html", date: date, products: products)
  end



  # defp shop_assistans() do
  #   Enum.map(Users.list_shop_assistans(), fn u -> {u.username, u.id} end)
  # end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user && conn.assigns.current_user.volunteer do
      assign(conn, :page, :purchaser)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
