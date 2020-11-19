defmodule AOFFWeb.Shop.PaymentCallbackController do
  use AOFFWeb, :controller

  alias AOFF.Users

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
          {:ok, order} ->
            Users.extend_memberships(order)
            # Create a new order for the basket.
            Users.create_order(prefix, %{"user_id" => order.user_id})
            accepted(conn, order, card_nr, paymenttype)

          _ ->
            error(conn)
        end

      true ->
        error(conn)
    end
  end

  defp card_nr(cardno) do
    String.slice(cardno, 12..15)
  end

  defp accepted(conn, order, card_nr, paymenttype) do
    send_invoice(conn.assigns.prefix, order, card_nr, paymenttype)

    conn
    |> render("index.html")
  end

  defp accepted(conn, _order) do
    conn
    |> render("index.html")
  end

  defp send_invoice(prefix, order, card_nr, paymenttype) do
    AOFFWeb.EmailController.invoice_email(prefix, order, card_nr, paymenttype)
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
