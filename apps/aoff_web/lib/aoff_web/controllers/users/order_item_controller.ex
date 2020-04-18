defmodule AOFFWeb.Users.OrderItemController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.Order
  # alias AOFF.Users.OrderItem
  alias AOFF.Shop
  alias AOFF.Shop.PickUp
  alias AOFF.Users.OrderItem

  def create(conn, %{"params" => params}) do
    user = Users.get_user!(params["user_id"])
    order = Users.current_order(params["user_id"])
    product = Shop.get_product!(params["product_id"])

    pick_up_params = %{
      "date_id" => params["date_id"],
      "user_id" => user.id,
      "username" => user.username,
      "member_nr" => user.member_nr,
      "order_id" => order.id,
      "email" => user.email
    }

    order_item_params =
      params
      |> Map.merge(%{
        "price" => product.price,
        "order_id" => order.id
      })

    result = Users.add_membership_to_basket(pick_up_params, order_item_params)

    case result do
      {:ok, %OrderItem{} = order_item} ->
        conn
        |> put_flash(
          :info,
          gettext("%{name} is added to your basket.", name: params["product_name"])
        )
        |> redirect(to: Routes.shop_date_path(conn, :show, params["date_id"]))

      {:error, reason} ->
        conn
        |> put_flash(:error, gettext("Sorry an error occured"))
        |> redirect(to: Routes.shop_date_path(conn, :show, params["date_id"]))
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item = Users.get_order_item!(id)
    order = order_item.order
    {:ok, _order_item} = Users.delete_order_item(order_item)

    conn
    |> put_flash(:info, gettext("Order item deleted successfully."))
    |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))
  end
end
