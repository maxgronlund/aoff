defmodule AOFFWeb.ShopAssistant.OrderController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Shop
  alias AOFFWeb.Users.Auth

  alias AOFF.Users.OrderItem

  plug Auth
  plug :authenticate when action in [:index, :show]

  def new(conn, %{"user_id" => user_id}) do
    IO.inspect order = Users.current_order(user_id)
    # products = Shop.list_products(:for_sale)

    changeset = Users.change_order_item(%OrderItem{})
    render(
      conn,
      "new.html",
      user: order.user,
      order: order,
      products: products(),
      dates: dates,
      changeset: changeset)
  end

  defp products() do
    products = Shop.list_products(:for_sale)
    Enum.map( products, fn x -> name_and_id(x) end)
  end

  defp name_and_id(product) do
    name =
      case Gettext.get_locale() do
        "en" ->
          {name_and_price(product.name_en, product.price), product.id}
        _ ->
          {name_and_price(product.name_da, product.price), product.id}
      end
  end

  defp name_and_price(name, price) do
    name <> " : " <> Money.to_string(price)
  end



  defp dates() do
    dates = Shop.list_dates(AOFF.Time.today(), 0, 4)
    Enum.map(dates, fn x -> {AOFF.Time.date_as_string(x.date), x.id} end)

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