defmodule AOFFWeb.Volunteers.BlogPostControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn
  import AOFF.Blogs.BlogPostFixture
  import AOFF.Blogs.BlogFixture
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  describe "volunteers" do
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

      blog = blog_fixture()
      {:ok, conn: conn, blog: blog}
    end

    test "post renders form", %{conn: conn, blog: blog} do
      conn = get(conn, Routes.volunteer_blog_blog_post_path(conn, :new, blog))
      assert html_response(conn, 200) =~ gettext("New Article")
    end

    test "create post redirects to edit when data is valid", %{conn: conn, blog: blog} do
      attrs = create_post_attrs()

      conn =
        post(conn, Routes.volunteer_blog_blog_post_path(conn, :create, blog), blog_post: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_blog_blog_post_path(conn, :edit, blog, id)

      conn = get(conn, Routes.volunteer_blog_blog_post_path(conn, :show, blog, id))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "create postrenders errors when data is invalid", %{conn: conn, blog: blog} do
      attrs = invalid_post_attrs()

      conn =
        post(conn, Routes.volunteer_blog_blog_post_path(conn, :create, blog), blog_post: attrs)

      assert html_response(conn, 200) =~ gettext("New Article")
    end

    test "edit post renders form for editing chosen post", %{conn: conn, blog: blog} do
      post = post_fixture(blog.id)
      conn = get(conn, Routes.volunteer_blog_blog_post_path(conn, :edit, blog, post))
      assert html_response(conn, 200) =~ gettext("Edit Article")
    end

    test "update blog redirects when data is valid", %{conn: conn, blog: blog} do
      post = post_fixture(blog.id)
      attrs = update_post_attrs()

      conn =
        put(conn, Routes.volunteer_blog_blog_post_path(conn, :update, blog, post),
          blog_post: attrs
        )

      assert redirected_to(conn) == Routes.volunteer_blog_blog_post_path(conn, :show, blog, post)

      conn = get(conn, Routes.volunteer_blog_blog_post_path(conn, :show, blog, post))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "renders errors when data is invalid", %{conn: conn, blog: blog} do
      post = post_fixture(blog.id)
      attrs = invalid_post_attrs()

      conn =
        put(conn, Routes.volunteer_blog_blog_post_path(conn, :update, blog, post),
          blog_post: attrs
        )

      assert html_response(conn, 200) =~ gettext("Edit Article")
    end

    alias AOFF.Blogs

    test "deletes chosen blog_post", %{conn: conn, blog: blog} do
      post = post_fixture(blog.id)
      conn = delete(conn, Routes.volunteer_blog_blog_post_path(conn, :delete, blog, post))
      # assert redirected_to(conn) == Routes.volunteer_blog_path(conn, :index, blog)
    end
  end
end
