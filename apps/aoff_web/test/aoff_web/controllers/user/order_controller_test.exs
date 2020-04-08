defmodule AOFFWeb.OrderControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext

  alias AOFF.Users
  import AOFF.Users.OrderFixture
  import AOFF.Users.UserFixture

  alias Plug.Conn

  # def fixture(:order) do
  #   {:ok, order} = Users.create_order(@create_attrs)
  #   order
  # end

  describe "user orders" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture()

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user}
    end

    test "index", %{conn: conn, user: user} do
      order = order_fixture(user.id)
      conn = get(conn, Routes.user_path(conn, :show, user))

      # assert html_response(conn, 200) =~ gettext("Listing Orders")
    end
  end

  # describe "new order" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.shop_order_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Order"
  #   end
  # end

  # describe "create order" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     attrs = create_order_attrs()
  #     conn = post(conn, Routes.shop_order_path(conn, :create), order: attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.shop_order_path(conn, :show, id)

  #     conn = get(conn, Routes.shop_order_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Order"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     attrs = invalid_order_attrs()
  #     conn = post(conn, Routes.shop_order_path(conn, :create), order: attrs)
  #     assert html_response(conn, 200) =~ "New Order"
  #   end
  # end

  # describe "edit order" do
  #   setup do
  #     user = user_fixture()
  #     order = order_fixture(user.id)
  #     {:ok, order: order}
  #   end

  #   test "renders form for editing chosen order", %{conn: conn, order: order} do
  #     conn = get(conn, Routes.shop_order_path(conn, :edit, order))
  #     assert html_response(conn, 200) =~ "Edit Order"
  #   end
  # end

  # describe "update order" do
  #   setup do
  #     user = user_fixture()
  #     order = order_fixture(user.id)
  #     {:ok, order: order}
  #   end

  #   test "redirects when data is valid", %{conn: conn, order: order} do
  #     attrs = update_order_attrs()
  #     conn = put(conn, Routes.shop_order_path(conn, :update, order), order: attrs)
  #     assert redirected_to(conn) == Routes.shop_order_path(conn, :show, order)

  #     conn = get(conn, Routes.shop_order_path(conn, :show, order))
  #     assert html_response(conn, 200) =~ "some updated state"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, order: order} do
  #     attrs = invalid_order_attrs()
  #     conn = put(conn, Routes.shop_order_path(conn, :update, order), order: attrs)
  #     assert html_response(conn, 200) =~ "Edit Order"
  #   end
  # end

  # describe "delete order" do
  #   setup do
  #     user = user_fixture()
  #     order = order_fixture(user.id)
  #     {:ok, order: order}
  #   end

  #   test "deletes chosen order", %{conn: conn, order: order} do
  #     conn = delete(conn, Routes.shop_order_path(conn, :delete, order))
  #     assert redirected_to(conn) == Routes.shop_order_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.shop_order_path(conn, :show, order))
  #     end
  #   end
  # end
end
