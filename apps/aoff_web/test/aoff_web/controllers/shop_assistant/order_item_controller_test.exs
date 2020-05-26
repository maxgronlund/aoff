defmodule AOFFWeb.ShopAssistant.OrderControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn
  alias AOFF.Users
  alias AOFF.Users.OrderItem

  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture
  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
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

    test "create/1 with valid date adds an order_item to an order", %{conn: conn} do

      user = user_fixture( %{
            "email" =>"guest-email@example.com",
            "member_nr" => 2,
            "username" => "Guest Joe"})

      order = order_fixture( user.id)
      date = date_fixture()
      product = product_fixture()

      conn =
        post(
          conn,
          Routes.shop_assistant_order_order_item_path(conn, :create, order),
          order_item: %{
            date_id: date.id,
            order_id: order.id,
            product_id: product.id,
            user_id: user.id
          }
        )
      assert redirected_to(conn) == Routes.shop_assistant_user_order_path(conn, :new, user)
    end

    test "create/1 with missing date" do
      assert false
    end

    test "create/1 with missing product" do
      assert false
    end
  end
end
