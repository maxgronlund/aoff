defmodule AOFFWeb.Shop.PaymentDeclinedController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    if order = Users.get_order_by_token!(prefix, id) do
      # Users.payment_declined(order)
      {:ok, message} =
        System.find_or_create_message(
          prefix,
          "shop/payment_declined",
          "Payment declined",
          Gettext.get_locale()
        )

      conn
      |> assign(:order_items_count, 0)
      |> render("index.html", order: order, message: message)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
