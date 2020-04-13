defmodule AOFFWeb.MessageControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.System.MessageFixture
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  alias AOFF.System
  alias Plug.Conn

  describe "unauthorized" do
    test "index renders 401", %{conn: conn} do
      conn = get(conn, Routes.volunteer_message_path(conn, :index))
      assert html_response(conn, 401) =~ "Unauthorized"
    end
  end

  describe "volunteer" do
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

    test "index lists all messages", %{conn: conn} do
      conn = get(conn, Routes.volunteer_message_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Text used on the site")
    end


    test "edit message renders form for editing chosen message", %{conn: conn} do

      message = message_fixture()
      conn = get(conn, Routes.volunteer_message_path(conn, :edit, message))
      assert html_response(conn, 200) =~
        gettext("Edit: %{identifier}-%{locale}",
          identifier: message.identifier,
          locale: message.locale
        )
    end

    test "update message redirects when data is valid", %{conn: conn} do
      message = message_fixture()
      attrs = update_message_attrs()
      conn = put(conn, Routes.volunteer_message_path(conn, :update, message), message: attrs)
      assert redirected_to(conn) == Routes.volunteer_message_path(conn, :show, message)

      conn = get(conn, Routes.volunteer_message_path(conn, :show, message))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      message = message_fixture()
      attrs = invalid_message_attrs()
      conn = put(conn, Routes.volunteer_message_path(conn, :update, message), message: attrs)
      assert html_response(conn, 200) =~
        gettext("Edit: %{identifier}-%{locale}",
          identifier: message.identifier,
          locale: message.locale
        )
    end

    test "delete message deletes chosen message", %{conn: conn} do
      message = message_fixture()
      conn = delete(conn, Routes.volunteer_message_path(conn, :delete, message))
      assert redirected_to(conn) == Routes.volunteer_message_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.volunteer_message_path(conn, :show, message))
      end
    end
  end

  # defp create_message(_) do
  #   message = fixture(:message)
  #   {:ok, message: message}
  # end
end
