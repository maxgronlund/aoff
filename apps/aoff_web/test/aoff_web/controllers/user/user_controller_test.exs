defmodule AOFFWeb.UserControllerTest do
  use AOFFWeb.ConnCase

  # alias AOFF.Users

  alias Plug.Conn
  alias AOFF.System
  alias AOFF.Users

  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  describe "as a member" do
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

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ gettext("Edit Account")
    end

    test "update user redirects when data is valid", %{conn: conn, user: user} do
      attrs = update_attrs(user.id)
      conn = put(conn, Routes.user_path(conn, :update, user), user: attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ attrs["username"]
    end

    test "update user renders errors when data is invalid", %{conn: conn, user: user} do
      attrs = invalid_attrs()
      conn = put(conn, Routes.user_path(conn, :update, user), user: attrs)
      assert html_response(conn, 200) =~ gettext("Edit Account")
    end

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      # assert_error_sent 404, fn ->
      #   get(conn, Routes.user_path(conn, :show, user))
      # end
    end
  end

  describe "as a guest" do
    test "render form for new user", %{conn: conn} do
      {:ok, message} =
        System.find_or_create_message(
          "/users/new",
          "Create account",
          Gettext.get_locale()
        )

      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ message.text
    end

    test "create user with valid data", %{conn: conn} do
      attrs = valid_attrs()
      conn = post(conn, Routes.user_path(conn, :create), user: attrs)
      user = Users.get_user_by_email(attrs["emial"])
      assert redirected_to(conn) == Routes.user_welcome_path(conn, :show, user)
    end

    test "create user with invalid data", %{conn: conn} do
      attrs = invalid_attrs()
      conn = post(conn, Routes.user_path(conn, :create), user: attrs)

      {:ok, message} =
        System.find_or_create_message(
          "/users/new",
          "Create account",
          Gettext.get_locale()
        )

      assert html_response(conn, 200) =~ message.title
    end
  end

  # defp create_user(_) do
  #   user = user_fixture()
  #   {:ok, user: user}
  # end
end
