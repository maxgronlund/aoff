defmodule AOFFWeb.Volunteer.PageControllerTest do
  use AOFFWeb.ConnCase

  import AOFFWeb.Gettext
  import AOFF.Content.CategoryFixture
  import AOFF.Content.PageFixture
  import AOFF.Users.UserFixture

  alias Plug.Conn

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

      category = category_fixture()
      {:ok, conn: conn, category: category}
    end

    test "new page renders form", %{conn: conn, category: category} do
      conn = get(conn, Routes.volunteer_category_page_path(conn, :new, category))
      assert html_response(conn, 200) =~ gettext("New Page")
    end

    test "create page redirects to edit when data is valid", %{conn: conn, category: category} do
      attrs = create_page_attrs()

      conn =
        post(
          conn,
          Routes.volunteer_category_page_path(
            conn,
            :create,
            category
          ),
          page: attrs
        )

      assert %{id: id} = redirected_params(conn)

      assert redirected_to(conn) ==
               Routes.volunteer_category_page_path(conn, :edit, category, id)

      conn = get(conn, Routes.about_page_path(conn, :show, category, id))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "edit page renders form for editing chosen page", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      conn = get(conn, Routes.volunteer_category_page_path(conn, :edit, category, page))
      assert html_response(conn, 200) =~ gettext("Edit %{title}", title: page.title)
    end

    test "update page redirects when data is valid", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      attrs = update_page_attrs()

      conn =
        put(conn, Routes.volunteer_category_page_path(conn, :update, category, page), page: attrs)

      assert redirected_to(conn) == Routes.about_page_path(conn, :show, category, attrs["title"])
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      attrs = invalid_page_attrs()

      conn =
        put(conn, Routes.volunteer_category_page_path(conn, :update, category, page), page: attrs)

      assert html_response(conn, 200) =~ gettext("Edit %{title}", title: page.title)
    end

    test "deletes chosen page", %{conn: conn, category: category} do
      page = page_fixture(category.id)

      conn =
        delete(
          conn,
          Routes.volunteer_category_page_path(
            conn,
            :delete,
            category,
            page
          )
        )

      assert redirected_to(conn) == Routes.about_path(conn, :show, category)
    end
  end
end
