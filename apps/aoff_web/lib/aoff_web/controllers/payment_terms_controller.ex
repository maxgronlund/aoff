defmodule AOFFWeb.PaymentTermsController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFFWeb.Users.Auth
  alias AOFF.Users
  plug Auth

  plug :authenticate when action in [:show]

  def show(conn, %{"order_id" => order_id}) do
    {:ok, message} =
      System.find_or_create_message(
        "/payment_terms",
        "Payment terms",
        Gettext.get_locale()
      )

    render(conn, :show, message: message, order_id: order_id)
  end

  def show(conn, _params) do
    order = Users.current_order(conn.assigns.current_user.id)
    conn |> redirect(to: Routes.payment_terms_path(conn, :show, order_id: order.id))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
