defmodule AOFFWeb.Shop.PaymentAcceptedControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture
  import AOFFWeb.Gettext
  alias Plug.Conn
  alias AOFF.Users

  describe "payment accepted" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"expiration_date" => AOFF.Time.today()})
      order = order_fixture(user.id, %{"payment_date" => AOFF.Time.now()})

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, order: order}
    end

    test "index/2 extends the membership", %{conn: conn, user: user, order: order} do
      product = product_fixture(%{"membership" => true, "state" => "open"})
      date = date_fixture()

      pick_up =
        pick_up_fixture(%{
          "date_id" => date.id,
          "user_id" => user.id,
          "order_id" => order.id
        })

      _order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "date_id" => date.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id
        })

      _conn =
        get(
          conn,
          Routes.shop_payment_accepted_path(
            conn,
            :index,
            order.token,
            %{
              cardno: "0000 0000 0000 0000",
              paymenttype: "1",
              orderid: "12341234"
            }
          )
        )

      assert Users.get_user!(user.id).expiration_date == Date.add(AOFF.Time.today(), 365)
    end

    test "index/2 updates the order state", %{conn: conn, user: user, order: order} do
      product = product_fixture(%{"membership" => true, "state" => "open"})
      date = date_fixture()

      pick_up =
        pick_up_fixture(%{
          "date_id" => date.id,
          "user_id" => user.id,
          "order_id" => order.id
        })

      _order_item =
        order_item_fixture(%{
          "order_id" => order.id,
          "product_id" => product.id,
          "date_id" => date.id,
          "user_id" => user.id,
          "pick_up_id" => pick_up.id
        })

      conn =
        get(
          conn,
          Routes.shop_payment_accepted_path(
            conn,
            :index,
            order.token,
            %{cardno: "0000000000001234", paymenttype: "1", orderid: "12341234"}
          )
        )

      assert html_response(conn, 200) =~ gettext("Back to the shop")
      order = Users.get_order!(order.id)
      assert order.state == "payment_accepted"
      assert order.card_nr == "xxxx xxxx xxxx 1234"
    end
  end
end
