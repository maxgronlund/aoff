defmodule AOFFWeb.ShopAssistant.OrderItemControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture
  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  # import AOFFWeb.Gettext

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

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(prefix: "public")

      {:ok, conn: conn, user: guest}
    end

    test "create/1 with valid date adds an order_item to an order",
         %{conn: conn, user: user} do
      order = order_fixture(user.id)
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

    test "create with missing date shows an error", %{conn: conn, user: user} do
      order = order_fixture(user.id)
      product = product_fixture()

      conn =
        post(
          conn,
          Routes.shop_assistant_order_order_item_path(conn, :create, order),
          order_item: %{
            date_id: "",
            order_id: order.id,
            product_id: product.id,
            user_id: user.id
          }
        )

      assert redirected_to(conn) ==
               Routes.shop_assistant_user_order_path(conn, :new, user)
    end

    test "create/1 with missing product shows an error", %{conn: conn, user: user} do
      order = order_fixture(user.id)
      date = date_fixture()

      conn =
        post(
          conn,
          Routes.shop_assistant_order_order_item_path(conn, :create, order),
          order_item: %{
            date_id: date.id,
            order_id: order.id,
            product_id: "",
            user_id: user.id
          }
        )

      assert redirected_to(conn) == Routes.shop_assistant_user_order_path(conn, :new, user)
    end

    test "delete removes the order item from the order", %{conn: conn, user: user} do
      order = order_fixture(user.id)
      date = date_fixture()
      product = product_fixture()

      pick_up =
        pick_up_fixture(%{
          "date_id" => date.id,
          "user_id" => user.id,
          "username" => user.username,
          "member_nr" => user.member_nr,
          "order_id" => order.id,
          "email" => user.email,
          "price" => product.price
        })

      order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id,
          "date_id" => date.id,
          "price" => product.price
        })

      conn =
        delete(
          conn,
          Routes.shop_assistant_order_order_item_path(conn, :delete, order, order_item),
          order_item: %{
            date_id: date.id,
            order_id: order.id,
            product_id: "",
            user_id: user.id
          }
        )

      assert redirected_to(conn) == Routes.shop_assistant_user_order_path(conn, :new, user)
    end
  end
end
