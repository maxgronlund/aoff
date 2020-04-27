defmodule AOFFWeb.Shop.PaymentDeclinedController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(conn, %{"id" => id}) do
    if order = Users.get_order_by_token!(id) do
      Users.payment_declined(order)
    end

    {:ok, message} =
      System.find_or_create_message(
        "shop/payment_declined",
        "Payment declined",
        Gettext.get_locale()
      )

    conn
    |> assign(:order_items_count, 0)
    |> render("index.html", order: order, message: message)
  end
end
