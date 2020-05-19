defmodule AOFFWeb.System.SMSMessageControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.System.SMSMessageFixture
  import AOFF.Users.UserFixture

  alias Plug.Conn

  describe "sms_messages" do
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

    test "lists all sms_messages", %{conn: conn} do
      conn = get(conn, Routes.system_sms_message_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Sms messages"
    end

    test "new sms_message renders form", %{conn: conn} do
      conn = get(conn, Routes.system_sms_message_path(conn, :new))
      assert html_response(conn, 200) =~ "New Sms message"
    end

    test "create sms_message redirects to show when data is valid", %{conn: conn, user: user} do
      attrs = valid_sms_message_attrs(%{"user_id" => user.id})
      conn = post(conn, Routes.system_sms_message_path(conn, :create), sms_message: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.system_sms_message_path(conn, :show, id)

      conn = get(conn, Routes.system_sms_message_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Sms message"
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.system_sms_message_path(conn, :create), sms_message: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "New Sms message"
    # end

    # test "delete sms_message deletes chosen sms_message", %{conn: conn, sms_message: sms_message} do
    #   conn = delete(conn, Routes.system_sms_message_path(conn, :delete, sms_message))
    #   assert redirected_to(conn) == Routes.system_sms_message_path(conn, :index)
    #   assert_error_sent 404, fn ->
    #     get(conn, Routes.system_sms_message_path(conn, :show, sms_message))
    #   end
    # end
  end
end
