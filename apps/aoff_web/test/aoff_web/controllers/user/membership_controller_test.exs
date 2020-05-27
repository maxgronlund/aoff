defmodule AOFFWeb.Users.MembershipControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture

  alias AOFF.System
  alias Plug.Conn

  describe "extend membership" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture()

      {:ok, message} =
        System.find_or_create_message(
          "/users/:id/membership/new/ - buy new",
          "Buy membership",
          Gettext.get_locale()
        )

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, message: message}
    end

    test "new", %{conn: conn, user: user, message: message} do
      conn = get(conn, Routes.user_membership_path(conn, :new, user))
      assert html_response(conn, 200) =~ message.title
    end
  end


end
