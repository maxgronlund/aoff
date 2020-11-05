defmodule AOFFWeb.Users.OrderItemController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Shop
  alias AOFF.Users.OrderItem

  def create(conn, %{"params" => params}) do
    prefix = conn.assigns.prefix
    user = Users.get_user!(params["user_id"], prefix)
    order = Users.current_order(params["user_id"], prefix)
    product = Shop.get_product!(params["product_id"], prefix)

    pick_up_params = %{
      "date_id" => params["date_id"],
      "user_id" => user.id,
      "username" => user.username,
      "member_nr" => user.member_nr,
      "order_id" => order.id,
      "email" => user.email
    }

    # TODO: add count to order item
    order_item_params =
      params
      |> Map.merge(%{
        "price" => product.price,
        "order_id" => order.id
      })

    result =
      Users.add_order_item_to_basket(
        pick_up_params,
        order_item_params,
        prefix
      )

    case result do
      {:ok, %OrderItem{} = _order_item} ->
        conn
        |> put_flash(
          :info,
          gettext("%{name} is added to your basket.", name: params["product_name"])
        )
        |> redirect(to: Routes.shop_date_path(conn, :show, params["date_id"]))

      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("Sorry an error occured"))
        |> redirect(to: Routes.shop_date_path(conn, :show, params["date_id"]))
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item = Users.get_order_item!(id)
    order = order_item.order
    {:ok, _order_item} = Users.delete_order_item(order_item, conn.assigns.prefix)

    conn
    |> put_flash(:info, gettext("Order item deleted successfully."))
    |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))
  end
end
