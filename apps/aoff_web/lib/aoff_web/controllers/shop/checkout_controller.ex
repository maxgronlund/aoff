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
      message: message,
      merchantnumber: Application.get_env(:aoff_web, :epay)[:merchantnumber]
    )
  end

  # def update(conn, %{"id" => id}) do
  #   order = Users.get_order!(id)
  #   conn
  #   |> redirect(to: Routes.shop_payment_accepted_path(conn, :index, order))
  # end
end
