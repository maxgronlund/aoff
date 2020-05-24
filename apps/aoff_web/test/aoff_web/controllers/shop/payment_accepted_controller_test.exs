defmodule AOFFWeb.Shop.PaymentAcceptedControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Shop.PickUpFixture
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
      product = product_fixture(%{"membership" => true, "state" => "open"})
      order = order_fixture(user.id)
      date = date_fixture()
      pick_up =
        pick_up_fixture(
          %{
            "date_id" => date.id,
            "user_id" => user.id,
            "order_id" => order.id
          }
        )
      order_item =
        order_item_fixture(
          %{
            "order_id" => order.id,
            "product_id" => product.id,
            "date_id" => date.id,
            "user_id" => user.id,
            "pick_up_id" => pick_up.id
          }
        )
      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, order: order}
    end

    test "index/2 extends the membership", %{conn: conn, user: user, order: order} do
      conn = get(conn, Routes.shop_payment_accepted_path(conn, :index, order.token))
      assert Users.get_user!(user.id).expiration_date == Date.add(AOFF.Time.today(), 365)
    end
  end

end