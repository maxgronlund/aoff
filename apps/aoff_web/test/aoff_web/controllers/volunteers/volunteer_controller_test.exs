defmodule AOFFWeb.Volunteer.VollunteerControllerTest do
  use AOFFWeb.ConnCase

  alias Plug.Conn
  import AOFF.Shop.DateFixture
  import AOFFWeb.Gettext
  import AOFF.Users.UserFixture

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

      date = date_fixture()
      {:ok, conn: conn, date: date}
    end

    test "render index", %{conn: conn} do
      conn = get(conn, Routes.volunteer_volunteer_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Opening dates")
    end
  end
end
