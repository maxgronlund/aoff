defmodule AOFFWeb.Content.CalendarControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.PageFixture
  import AOFF.Users.UserFixture
  import AOFF.Content.CategoryFixture
  import AOFFWeb.Gettext
  alias Plug.Conn
  alias AOFF.Content.Page

  describe "handle the calendar as a text_editor" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"text_editor" => true})


      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user}
    end

    test "render new", %{conn: conn, user: user} do
      conn = get(conn, Routes.volunteer_calendar_path(conn, :new))
      assert html_response(conn, 200) =~ gettext("New event")
    end

    test "create a new event for the calendar", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      attrs = create_page_attrs()
      conn = post(conn, Routes.volunteer_calendar_path(conn, :create), page: attrs)
      # assert html_response(conn, 200) =~ gettext("Edit event")
      assert redirected_to(conn) == Routes.volunteer_calendar_path(conn, :edit, attrs["title"])
    end
  end
end