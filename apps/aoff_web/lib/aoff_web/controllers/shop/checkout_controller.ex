defmodule AOFFWeb.Shop.CheckoutController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def edit(conn, %{"id" => id}) do
    {:ok, message} =
      System.find_or_create_message(
        "/shop/checkout/:id/new",
        "Checkout",
        Gettext.get_locale()
      )

    order = Users.get_order!(id)


    changeset = Users.change_order(order)

    render(
      conn,
      "edit.html",
      changeset: changeset,
      order: order,
      message: message
    )
  end

  def update(conn, %{"id" => id}) do
    order = Users.get_order!(id)

    # TODO here we are muging the response from the payment gateway

    conn
    |> redirect(to: Routes.shop_payment_accepted_path(conn, :index, order))

    # changeset = Users.change_order(order)
  end

  # def show(conn, params) do
  #   order = Users.get_order!(params["id"])
  #   changeset = Users.change_order(order)
  #   render(conn, "show.html", changeset: changeset, order: order)
  # end

  # def update(conn, %{"id" => id, "order" => order_params}) do
  #   order = Users.get_order!(id)

  #   Users.update_order(order, order_params)

  #   conn
  #   |> put_flash(:info, gettext("Your order is processed"))
  #   |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))

  #   # case Users.update_order(order, order_params) do
  #   #   {:ok, order} ->
  #   #     conn
  #   #     |> put_flash(:info, gettext("Order updated successfully."))
  #   #     |> redirect(to: Routes.user_order_path(conn, :show, order.user, order))

  #   #   {:error, %Ecto.Changeset{} = changeset} ->
  #   #     render(conn, "edit.html", user: order.user, order: order, changeset: changeset)
  #   # end
  # end
end
