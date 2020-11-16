defmodule AOFFWeb.Users.MembershipController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Shop
  alias AOFF.System
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:new, :create]

  def new(conn, %{"user_id" => user_id}) do
    prefix = conn.assigns.prefix
    conn = assign(conn, :selected_menu_item, :user)
    date = Shop.get_next_date(prefix, Date.utc_today())
    user = Users.get_user!(prefix, user_id)
    products = Shop.get_memberships(prefix)

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "/users/:id/membership/new/ - buy new",
        "Buy membership",
        Gettext.get_locale()
      )

    render(
      conn,
      "new.html",
      user: user,
      products: products,
      date: date,
      message: message
    )
  end

  def create(conn, %{"user_id" => user_id, "product_id" => product_id}) do
    prefix = conn.assigns.prefix
    user = Users.get_user!(prefix, user_id)
    order = Users.current_order(prefix, user_id)
    product = Shop.get_product!(prefix, product_id)
    date = Shop.get_next_date(prefix, Date.utc_today())

    pick_up_params = %{
      "date_id" => date.id,
      "user_id" => user.id,
      "username" => user.username,
      "member_nr" => user.member_nr,
      "order_id" => order.id,
      "email" => user.email
    }

    order_item_params = %{
      "order_id" => order.id,
      "date_id" => date.id,
      "user_id" => user.id,
      "product_id" => product.id,
      "price" => product.price
    }

    Users.add_order_item_to_basket(prefix, pick_up_params, order_item_params)

    conn
    |> redirect(to: Routes.shop_checkout_path(conn, :edit, order))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
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
