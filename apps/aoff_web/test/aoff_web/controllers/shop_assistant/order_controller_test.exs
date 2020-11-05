defmodule AOFFWeb.ShopAssistant.OrderControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn

  import AOFF.Shop.DateFixture
  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFFWeb.Gettext

  describe "shop assistant" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"shop_assistant" => true})

      guest =
        user_fixture(%{
          "email" => "guest-email@example.com",
          "member_nr" => 2,
          "username" => "Guest Joe"
        })

      date = date_fixture()

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> put_session(:shop_assistant_date_id, date.id)
        |> configure_session(renew: true)
        |> assign(prefix: "public")

      {:ok, conn: conn, user: guest, date: date}
    end

    test "new shows order by user_id", %{conn: conn, user: user} do
      _order = order_fixture(user.id)

      conn =
        get(
          conn,
          Routes.shop_assistant_user_order_path(conn, :new, user.id)
        )

      assert html_response(conn, 200) =~
               gettext("Create Order for: %{username}", username: user.username)
    end

    test "delete empties the order and redirect", %{conn: conn, user: user, date: date} do
      order = order_fixture(user.id)

      conn =
        delete(
          conn,
          Routes.shop_assistant_user_order_path(conn, :delete, user.id, order)
        )

      assert redirected_to(conn) == Routes.shop_assistant_date_path(conn, :show, date)
    end
  end
end
