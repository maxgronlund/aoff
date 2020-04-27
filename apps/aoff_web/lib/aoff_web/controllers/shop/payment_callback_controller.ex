defmodule AOFFWeb.Shop.PaymentCallbackController do
  use AOFFWeb, :controller

  alias AOFF.Users

  def index(conn, %{"id" => id}) do
    order = Users.get_order_by_token!(id)

    if order.state == "open" do
      Users.payment_accepted(order)
      Users.create_order(%{"user_id" => order.user_id})
      Users.extend_memberships(order)
    end

    conn
    |> assign(:order_items_count, 0)
    |> render("index.html")
  end
end
