defmodule AOFFWeb.Shop.CheckoutController do
  use AOFFWeb, :controller

  alias AOFF.Users

  def show(conn, params) do
    order = Users.get_order!(params["id"])
    changeset = Users.change_order(order)
    render(conn, "show.html", changeset: changeset, order: order)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    IO.inspect order_params
    order = Users.get_order!(id)

    Users.update_order(order, order_params)

    update_account(order)

    conn
    |> put_flash(:info, gettext("Your order is processed"))
    |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))

    # case Users.update_order(order, order_params) do
    #   {:ok, order} ->
    #     conn
    #     |> put_flash(:info, gettext("Order updated successfully."))
    #     |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "edit.html", user: order.user, order: order, changeset: changeset)
    # end
  end

  def update_account(order) do

    for order_item <- order.order_items do
      if order_item.product.membership do
        IO.puts "======== OHEY there is a membership ======"
        IO.inspect order.user
      else
        IO.puts " ===== NO membership ====="
      end
    end
  end
end
