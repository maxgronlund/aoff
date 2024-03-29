defmodule AOFFWeb.ShopAssistant.OrderController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Shop
  alias AOFFWeb.Users.Auth

  alias AOFF.Users.OrderItem

  plug Auth
  plug :authenticate when action in [:index, :show]

  def new(conn, %{"user_id" => user_id}) do
    prefix = conn.assigns.prefix
    order = Users.current_order(prefix, user_id)
    date_id = get_session(conn, :shop_assistant_date_id)
    date = Shop.get_date!(prefix, date_id)
    changeset = Users.change_order_item(%OrderItem{})

    render(
      conn,
      "new.html",
      user: order.user,
      order: order,
      date: date,
      products: products(prefix),
      dates: dates(prefix),
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    order = Users.get_order!(prefix, id)

    case Users.payment_accepted(order, "cash") do
      {:ok, order} ->
        Users.extend_memberships(order)
        send_invoice(prefix, order, "", "cash")
        # Create a new order for the basket.
        Users.create_order(prefix, %{"user_id" => order.user_id})

        case get_session(conn, :shop_assistant_date_id) do
          nil ->
            conn
            |> put_flash(:info, gettext("Order created and paied"))
            |> redirect(to: Routes.shop_assistant_date_path(conn, :index))

          date_id ->
            conn
            |> put_flash(:info, gettext("Order created and paied"))
            |> redirect(to: Routes.shop_assistant_date_path(conn, :show, date_id))
        end

      _ ->
        error(conn)
    end
  end

  defp send_invoice(prefix, order, cardno, paymenttype) do
    AOFFWeb.EmailController.invoice_email(prefix, order, cardno, paymenttype)
    |> AOFFWeb.Mailer.deliver_now()
  end

  def delete(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    order = Users.get_order!(prefix, id)
    Users.delete_order(order)

    date_id = get_session(conn, :shop_assistant_date_id)

    conn
    |> put_flash(:info, gettext("Order is cancled"))
    |> redirect(to: Routes.shop_assistant_date_path(conn, :show, date_id))
  end

  def error(conn) do
    conn
    |> put_status(401)
    |> put_view(AOFFWeb.ErrorView)
    |> render(:"401")
    |> halt()
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
    dates = Shop.list_dates(prefix, Date.add(AOFF.Time.today(), -7), 0, 7)
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
