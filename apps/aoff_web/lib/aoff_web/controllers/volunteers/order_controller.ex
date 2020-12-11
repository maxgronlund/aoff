defmodule AOFFWeb.Volunteer.OrderController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFFWeb.Users.Auth
  alias AOFF.Users.OrderItem
  alias AOFF.Shop
  plug Auth
  plug :authenticate when action in [:index]

  @orders_pr_page 8

  def index(conn, params) do
    prefix = conn.assigns.prefix
    page = page(params)
    pages_count = pages_count(prefix, params)

    orders =
      if query = params["query"] do
        Users.search_orders(prefix, query)
      else
        Users.list_orders(prefix, :all, page, @orders_pr_page)
      end

    conn
    |> put_session(:shop_assistant_date_id, nil)
    |> render("index.html",
      orders: orders,
      page: page,
      pages_count: pages_count
    )
  end

  defp page(params) do
    cond do
      params["query"] -> false
      true -> String.to_integer(params["page"] || "0")
    end
  end

  defp pages_count(prefix, params) do
    cond do
      params["query"] -> false
      true -> Users.order_pages_count(prefix, @orders_pr_page)
    end
  end

  # touched

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    order = Users.get_order!(prefix, id)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    order = Users.get_order!(prefix, id)

    changeset = Users.change_order_item(%OrderItem{})

    render(
      conn,
      "edit.html",
      user: order.user,
      order: order,
      products: products(prefix),
      dates: dates(prefix),
      changeset: changeset
    )
  end

  defp products(prefix) do
    products = Shop.list_products(prefix, :for_sale)
    Enum.map(products, fn x -> name_and_id(x) end)
  end

  defp name_and_id(product) do
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

  defp dates(prefix) do
    dates = Shop.list_dates(prefix, Date.add(AOFF.Time.today(), 0), 0, 5)
    Enum.map(dates, fn x -> {AOFF.Time.date_as_string(x.date), x.id} end)
  end

  def delete(conn, %{"id" => id}) do
    order = Users.get_order!(id, conn.assigns.prefix)
    Users.delete_order(order)

    date_id = get_session(conn, :shop_assistant_date_id)

    if date_id do
      conn
      |> put_flash(:info, gettext("Order is deleted"))
      |> redirect(to: Routes.shop_assistant_date_path(conn, :show, date_id))
    else
      conn
      |> put_flash(:info, gettext("Order is cancled"))
      |> redirect(to: Routes.volunteer_order_path(conn, :index))
    end
  end

  # def delete(conn, %{"id" => id}) do

  #   order = Users.get_order(id, "public")
  #   {:ok, _order} = Users.delete_order(order)

  #   conn
  #   |> put_flash(:info, gettext("Order deleted."))
  #   |> redirect(to: Routes.volunteer_order_path(conn, :index))
  # end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :selected_menu_item, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
