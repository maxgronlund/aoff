defmodule AOFFWeb.Shop.CheckoutControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  import AOFF.Users.OrderFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Users.UserFixture
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Users.OrderItemFixture
  import AOFF.Shop.PickUpFixture
  alias Plug.Conn

  describe "checkout" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      date = date_fixture()
      user = user_fixture()
      product = product_fixture()
      order = order_fixture(user.id, %{"state" => "open"})
      pick_up = pick_up_fixture(
        %{
          "date_id" => date.id,
          "user_id" => user.id,
          "username" => user.username,
          "member_nr" => user.member_nr,
          "order_id" => order.id,
          "email" => user.email
        }

      )
      order_item =
        order_item_fixture(
          %{
            "order_id" => order.id,
            "product_id" => product.id,
            "price" => product.price,
            "user_id" => user.id,
            "date_id" => date.id,
            "pick_up_id" => pick_up.id
          }
        )

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, order: order, product: product}
    end

    test "edit", %{conn: conn, user: user, order: order, product: product} do

      conn = get(conn, Routes.shop_checkout_path(conn, :edit, order))
      assert html_response(conn, 200) =~ product.name_da
    end
  end

end
