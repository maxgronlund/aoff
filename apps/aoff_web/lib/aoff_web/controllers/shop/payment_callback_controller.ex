defmodule AOFFWeb.Shop.PaymentCallbackController do
  use AOFFWeb, :controller

  alias AOFF.Users

  def index(conn, %{"id" => id, "cardno" => cardno, "paymenttype" => paymenttype}) do
    order = Users.get_order_by_token!(id)

    cond do
      order && order.state == "open" ->
        case Users.payment_accepted(order, paymenttype) do
          {:ok, %Users.Order{}} ->
            Users.extend_memberships(order)
            # Create a new order for the basket.
            Users.create_order(%{"user_id" => order.user_id})
            accepted(conn, order, cardno, paymenttype)
          _ ->
            error(conn)
        end
      order ->
        accepted(conn, order, cardno, paymenttype)
      true -> error(conn)
    end
  end



  defp accepted(conn, order, cardno, paymenttype) do
    send_invoice(order, cardno, paymenttype)
    conn
    |> render("index.html")
  end


  defp send_invoice(order, cardno, paymenttype) do
    AOFFWeb.Email.invoice_email(order, cardno, paymenttype)
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
