defmodule AOFFWeb.Shop.PaymentAcceptedController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(conn, %{"id" => id}) do
    order = Users.get_order_by_token!(id)

    if order.state == "open" do
      case Users.payment_accepted(order) do
        {:ok, %Users.Order{}} ->
          Users.extend_memberships(order)
          # Create a new order for the basket.
          Users.create_order(%{"user_id" => order.user_id})
          accepted(conn, order)

        _ ->
          error(conn)
      end
    end
  end

  defp accepted(conn, order) do
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

  def error(conn) do
    conn
    |> put_status(401)
    |> put_view(AOFFWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end
end
