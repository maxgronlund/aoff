defmodule AOFFWeb.ShopAssistant.OrderControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn
  alias AOFF.Users

  # import AOFF.Shop.DateFixture
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
      # date = date_fixture()

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user}
    end

    test "new/1 shows order by user_id", %{conn: conn} do

      user =
        user_fixture(
          %{
            "email" =>"guest-email@example.com",
            "member_nr" => 2,
            "username" => "Guest Joe"
          }
        )
      order = order_fixture( user.id)

      conn =
        get(
          conn,
          Routes.shop_assistant_user_order_path(conn, :new, user.id)
        )

      assert html_response(conn, 200) =~ gettext("Create Order")
    end
  end
end
