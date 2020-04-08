defmodule AOFFWeb.Volunteers.BlogControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  alias AOFF.Blogs
  alias Plug.Conn

  import AOFF.Blogs.BlogFixture
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

      {:ok, conn: conn}
    end

    test "lists all blogs", %{conn: conn} do
      conn = get(conn, Routes.volunteer_blog_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Blogs")
    end

    test "new blog renders form", %{conn: conn} do
      conn = get(conn, Routes.volunteer_blog_path(conn, :new))
      assert html_response(conn, 200) =~ gettext("New Blog")
    end

    test "create blog redirects to show when data is valid", %{conn: conn} do
      attrs = create_blog_attrs()
      conn = post(conn, Routes.volunteer_blog_path(conn, :create), blog: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_blog_path(conn, :show, id)

      conn = get(conn, Routes.volunteer_blog_path(conn, :show, id))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = invalid_blog_attrs()
      conn = post(conn, Routes.volunteer_blog_path(conn, :create), blog: attrs)
      assert html_response(conn, 200) =~ gettext("New Blog")
    end

    test "edit blog renders form for editing chosen blog", %{conn: conn} do
      blog = blog_fixture()
      conn = get(conn, Routes.volunteer_blog_path(conn, :edit, blog))
      assert html_response(conn, 200) =~ gettext("Edit Blog")
    end

    test "update blog redirects when data is valid", %{conn: conn} do
      blog = blog_fixture()
      attrs = update_blog_attrs()
      conn = put(conn, Routes.volunteer_blog_path(conn, :update, blog), blog: attrs)
      assert redirected_to(conn) == Routes.volunteer_blog_path(conn, :show, blog)

      conn = get(conn, Routes.volunteer_blog_path(conn, :show, blog))
      assert html_response(conn, 200) =~ attrs["description"]
    end

    test "update blog renders errors when data is invalid", %{conn: conn} do
      blog = blog_fixture()
      attrs = invalid_blog_attrs()
      conn = put(conn, Routes.volunteer_blog_path(conn, :update, blog), blog: attrs)
      assert html_response(conn, 200) =~ gettext("Edit Blog")
    end

    test "deletes chosen blog", %{conn: conn} do
      blog = blog_fixture()
      conn = delete(conn, Routes.volunteer_blog_path(conn, :delete, blog))
      assert redirected_to(conn) == Routes.volunteer_blog_path(conn, :index)
    end
  end
end
