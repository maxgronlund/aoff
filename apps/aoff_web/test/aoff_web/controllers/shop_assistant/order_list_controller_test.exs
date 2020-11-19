defmodule AOFFWeb.ShopAssistant.OrderListControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn

  import AOFF.Shop.DateFixture
  import AOFF.Users.UserFixture
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
      date = date_fixture()

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(prefix: "public")

      {:ok, conn: conn, date: date}
    end

    test "show order list", %{conn: conn, date: date} do
      conn = get(conn, Routes.shop_assistant_order_list_path(conn, :show, date))
      assert html_response(conn, 200) =~ gettext("Order list")
    end
  end
end
