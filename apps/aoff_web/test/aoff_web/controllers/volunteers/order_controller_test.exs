defmodule AOFFWeb.Volunteer.OrderControllerTest do
  use AOFFWeb.ConnCase

  # alias AOFF.Users

  alias Plug.Conn

  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFFWeb.Gettext

  describe "as a volunteer" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => true})

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user}
    end

    test "list orders", %{conn: conn, user: user} do
      conn = get(conn, Routes.volunteer_order_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Orders")
    end

    test "show order", %{conn: conn, user: user} do
      order = order_fixture(user.id)
      conn = get(conn, Routes.volunteer_order_path(conn, :show, order))
      assert html_response(conn, 200) =~ Integer.to_string(order.order_nr)
    end

    test "delete order", %{conn: conn, user: user} do
      order = order_fixture(user.id)
      conn = delete(conn, Routes.volunteer_order_path(conn, :delete, order))
      assert redirected_to(conn) == Routes.volunteer_order_path(conn, :index)
    end

    # test "update user redirects when data is valid", %{conn: conn, user: user} do
    #   attrs = update_attrs(user.id)
    #   conn = put(conn, Routes.volunteer_user_path(conn, :update, user), user: attrs)
    #   assert redirected_to(conn) == Routes.volunteer_user_path(conn, :index)

    #   conn = get(conn, Routes.volunteer_user_path(conn, :show, user))
    #   assert html_response(conn, 200) =~ attrs["username"]
    # end

    # test "update user renders errors when data is invalid", %{conn: conn, user: user} do
    #   attrs = invalid_attrs()
    #   conn = put(conn, Routes.volunteer_user_path(conn, :update, user), user: attrs)
    #   assert html_response(conn, 200) =~ gettext("Edit Account")
    # end

    # test "deletes chosen user", %{conn: conn, user: user} do
    #   userb =
    #     user_fixture(%{
    #       "username" => "delete me",
    #       "member_nr" => 12_341_234,
    #       "email" => "delete-me@example.com"
    #     })

    #   conn = delete(conn, Routes.volunteer_user_path(conn, :delete, userb))
    #   assert redirected_to(conn) == Routes.volunteer_user_path(conn, :index)
    # end
  end
end
