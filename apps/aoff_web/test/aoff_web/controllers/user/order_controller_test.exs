defmodule AOFFWeb.Users.OrderControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext

  import AOFF.Users.OrderFixture
  import AOFF.Users.UserFixture
  import AOFF.Admin.AssociationFixture

  alias Plug.Conn

  describe "user orders" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      _association = association_fixture()
      user = user_fixture()

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(:prefix, "public")

      {:ok, conn: conn, user: user}
    end

    test "show the basket", %{conn: conn, user: user} do
      order = order_fixture(user.id, %{"state" => "open"})
      conn = get(conn, Routes.user_order_path(conn, :show, user, order))

      assert html_response(conn, 200) =~ gettext("Basket")
    end

    test "delete deletes the order", %{conn: conn, user: user} do
      order = order_fixture(user.id, %{"state" => "open"})

      conn = delete(conn, Routes.user_order_path(conn, :delete, user, order))
      assert redirected_to(conn) == Routes.shop_shop_path(conn, :index)
    end
  end
end
