defmodule AOFFWeb.Volunteer.NewsletterControllerTest do
  use AOFFWeb.ConnCase

  alias AOFF.Volunteers

  import AOFF.Users.UserFixture
  import AOFF.Volunteer.NewsletterFixture
  import AOFFWeb.Gettext
  alias Plug.Conn

  describe "unauthorized" do
    test "index renders 401", %{conn: conn} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :index))
      assert html_response(conn, 401) =~ "401"
    end

    test "new renders 401", %{conn: conn} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :new))
      assert html_response(conn, 401) =~ "401"
    end

    test "edit renders 401", %{conn: conn} do
      newsletter = newsletter_fixture()
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :edit, newsletter))
      assert html_response(conn, 401) =~ "401"
    end

    test "show renders 401", %{conn: conn} do
      newsletter = newsletter_fixture()
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :show, newsletter))
      assert html_response(conn, 401) =~ "401"
    end
  end

  describe "text editor handles newsletter" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => true, "text_editor" => true})
      # AOFF.Users.set_bounce_to_url(user, "/")

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user}
    end

    test "index lists all newsletters", %{conn: conn} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Newsletters")
    end

    test "new renders form", %{conn: conn} do
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :new))
      assert html_response(conn, 200) =~ gettext("New Newsletter")
    end

    test "update redirects to show when data is valid", %{conn: conn} do
      attrs = valid_newsletter_attrs()
      conn = post(conn, Routes.volunteer_newsletter_path(conn, :create), newsletter: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :show, id)

      conn = get(conn, Routes.volunteer_newsletter_path(conn, :show, id))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "create  renders errors when data is invalid", %{conn: conn} do
      attrs = invalid_newsletter_attrs()
      conn = post(conn, Routes.volunteer_newsletter_path(conn, :create), newsletter: attrs)
      assert html_response(conn, 200) =~ gettext("New Newsletter")
    end

    test "renders form for editing chosen newsletter", %{conn: conn} do
      newsletter = newsletter_fixture()
      conn = get(conn, Routes.volunteer_newsletter_path(conn, :edit, newsletter))
      assert html_response(conn, 200) =~ gettext("Edit Newsletter")
    end

    test "redirects when data is valid", %{conn: conn} do
      newsletter = newsletter_fixture()
      attrs = update_newsletter_attrs()

      conn =
        put(conn, Routes.volunteer_newsletter_path(conn, :update, newsletter), newsletter: attrs)

      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :show, newsletter)

      conn = get(conn, Routes.volunteer_newsletter_path(conn, :show, newsletter))
      assert html_response(conn, 200) =~ attrs["author"]
    end

    test "edit renders errors when data is invalid", %{conn: conn} do
      newsletter = newsletter_fixture()
      attrs = invalid_newsletter_attrs()

      conn =
        put(conn, Routes.volunteer_newsletter_path(conn, :update, newsletter), newsletter: attrs)

      assert html_response(conn, 200) =~ gettext("Edit Newsletter")
    end

    test "deletes chosen newsletter", %{conn: conn} do
      newsletter = newsletter_fixture()
      conn = delete(conn, Routes.volunteer_newsletter_path(conn, :delete, newsletter))
      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.volunteer_newsletter_path(conn, :show, newsletter))
      end
    end
  end
end
