defmodule AOFFWeb.Shop.PaymentAcceptedController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(
        conn,
        %{
          "id" => id,
          "cardno" => cardno,
          "paymenttype" => paymenttype,
          "orderid" => order_id
        }
      ) do
    prefix = conn.assigns.prefix
    order = Users.get_order_by_token!(prefix, id)
    card_nr = "xxxx xxxx xxxx " <> card_nr(cardno)

    cond do
      order && order.state == "payment_accepted" ->
        accepted(conn, order)

      order && order.state == "open" ->
        case Users.payment_accepted(order, paymenttype, card_nr, order_id) do
          {:ok, %Users.Order{}} ->
            Users.extend_memberships(order)
            # Create a new order for the basket.
            Users.create_order(%{"user_id" => order.user_id})
            accepted(conn, order, cardno, paymenttype)

          _ ->
            error(conn)
        end

      true ->
        error(conn)
    end
  end

  defp card_nr(cardno \\ "") do
    String.slice(cardno, 12..15)
  end

  defp accepted(conn, order, cardno, paymenttype) do
    prefix = conn.assigns.prefix
    send_invoice(prefix, order, card_nr(cardno), paymenttype)

    conn
    |> assign(:order_items_count, 0)
    |> render("index.html", order: order, message: message(prefix))
  end

  defp accepted(conn, order) do
    conn
    |> render("index.html", order: order, message: message(conn.assigns.prefix))
  end

  defp message(prefix) do
    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "shop/payment_accepted",
        "Payment accepted",
        Gettext.get_locale()
      )

    message
  end

  defp send_invoice(prefix, order, cardno, paymenttype) do
    AOFFWeb.EmailController.invoice_email(prefix, order, cardno, paymenttype)
    |> AOFFWeb.Mailer.deliver_now()
  end

  def error(conn) do
    conn
    |> put_status(401)
    |> put_view(AOFFWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end
end
