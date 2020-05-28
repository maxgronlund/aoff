defmodule AOFFWeb.PaymentTermsController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Users
  alias AOFFWeb.Users.Auth
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
