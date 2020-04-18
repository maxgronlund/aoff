defmodule AOFFWeb.Shop.PaymentAcceptedController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System
  alias AOFF.Shop

  def index(conn, %{"id" => id}) do
    order = Users.get_order!(id)

    if order.state == "open" do
      Users.payment_accepted(order)
      Users.create_order(%{"user_id" => order.user_id})
      Users.extend_memberships(order)
    end

    {:ok, message} =
      System.find_or_create_message(
        "shop/payment_accepted",
        "Payment accepted",
        Gettext.get_locale()
      )

    conn
    |> assign(:order_items_count, 0)
    |> render("index.html", order: order, message: message)
  end
end
