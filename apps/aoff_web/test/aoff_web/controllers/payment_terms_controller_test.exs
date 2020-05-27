defmodule AOFFWeb.PaymentTermsControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  alias Plug.Conn
  alias AOFF.System

  describe "payment_terms" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture()
      order = order_fixture(user.id, %{"state" => "open"})

      {:ok, message} =
      System.find_or_create_message(
        "/payment_terms",
        "Payment terms",
        Gettext.get_locale()
      )


      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, order: order, message: message}
    end


    test "show", %{conn: conn, order: order, message: message} do
      conn = get(conn, Routes.payment_terms_path(conn, :show, order_id: order.id))

      assert html_response(conn, 200) =~ message.title
    end
  end
end