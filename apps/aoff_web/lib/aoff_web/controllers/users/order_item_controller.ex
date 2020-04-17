defmodule AOFFWeb.Users.OrderItemController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.Order
  # alias AOFF.Users.OrderItem
  alias AOFF.Shop
  alias AOFF.Shop.PickUp

  # def index(conn, _params) do
  #   order_items = Users.list_order_items()
  #   render(conn, "index.html", order_items: order_items)
  # end

  def create(conn, %{"params" => params}) do

    user = Users.get_user!(params["user_id"])

    IO.inspect Users.current_order(params["user_id"])

    order = Users.current_order(params["user_id"])
    {price, _} = params["price"] |> Float.parse()

    {:ok, pick_up} =
      Shop.find_or_create_pick_up(%{
        "date_id" => params["date_id"],
        "user_id" => user.id,
        "username" => user.username,
        "member_nr" => user.member_nr,
        "order_id" => order.id,
        "email" => user.email
      }
    )

    params
    |> Map.merge(
      %{
        "price" => Money.new(trunc(price), :DKK),
        "order_id" => order.id,
        "pick_up_id" => pick_up.id
      }
    )
    |> Users.create_order_item()

    conn
    |> put_flash(:info, gettext("%{name} is added to your basket.", name: params["product_name"]))
    |> redirect(to: Routes.shop_date_path(conn, :show, params["date_id"]))
  end

  # def create(conn, %{"order_item" => order_item_params}) do
  #   case Users.create_order_item(order_item_params) do
  #     {:ok, order_item} ->
  #       conn
  #       |> put_flash(:info, gettext("Order item created successfully."))
  #       |> redirect(to: Routes.order_item_path(conn, :show, order_item))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   order_item = Users.get_order_item!(id)
  #   render(conn, "show.html", order_item: order_item)
  # end

  # def edit(conn, %{"id" => id}) do
  #   order_item = Users.get_order_item!(id)
  #   changeset = Users.change_order_item(order_item)
  #   render(conn, "edit.html", order_item: order_item, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "order_item" => order_item_params}) do
  #   order_item = Users.get_order_item!(id)

  #   case Users.update_order_item(order_item, order_item_params) do
  #     {:ok, order_item} ->
  #       conn
  #       |> put_flash(:info, gettext("Order item updated successfully."))
  #       |> redirect(to: Routes.order_item_path(conn, :show, order_item))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", order_item: order_item, changeset: changeset)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    order_item = Users.get_order_item!(id)
    order = order_item.order
    {:ok, _order_item} = Users.delete_order_item(order_item)

    conn
    |> put_flash(:info, gettext("Order item deleted successfully."))
    |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))
  end
end
