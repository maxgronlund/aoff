defmodule AOFFWeb.SessionControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext
  alias AOFF.Users
  alias Plug.Conn

  describe "account confirmed" do
    test "redirect to user when credentials are valid", %{conn: conn} do
      attrs = valid_attrs()
      user = user_fixture()
      Users.confirm_user(user)
      conn = assign(conn, prefix: "public")

      conn =
        post(
          conn,
          Routes.session_path(
            conn,
            :create,
            %{
              "session" => %{"email" => attrs["email"], "password" => attrs["password"]}
            }
          )
        )

      assert redirected_to(conn) == Routes.user_path(conn, :show, user.id)
    end

    test "render new when credentials are invalid", %{conn: conn} do
      user = user_fixture()
      Users.confirm_user(user)
      conn = assign(conn, prefix: "public")

      conn =
        post(
          conn,
          Routes.session_path(
            conn,
            :create,
            %{
              "session" => %{
                "email" => "invalid amail",
                "password" => "invalid password"
              }
            }
          )
        )

      assert html_response(conn, 200) =~
               gettext("Invalid email/password combination")
    end
  end

  describe "accunt not confirmed" do
    test "redirect to confirm_email when credentials are valid", %{conn: conn} do
      attrs = valid_attrs()
      _user = user_fixture()
      conn = assign(conn, prefix: "public")

      conn =
        post(
          conn,
          Routes.session_path(
            conn,
            :create,
            %{
              "session" => %{
                "email" => attrs["email"],
                "password" => attrs["password"]
              }
            }
          )
        )

      user = Users.get_user_by_email(attrs["email"], "public")

      assert redirected_to(conn) ==
               Routes.confirm_email_path(conn, :show, user)
    end
  end

  describe "user is logged in" do
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
        |> assign(prefix: "public")

      {:ok, conn: conn, user: user}
    end

    test "logout", %{conn: conn, user: user} do
      conn = delete(conn, Routes.session_path(conn, :delete, user))
      conn = assign(conn, prefix: "public")
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end
end
