defmodule AOFFWeb.Content.PageControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.PageFixture
  import AOFF.Content.CategoryFixture
  import AOFF.Admin.AssociationFixture
  import AOFFWeb.Gettext

  describe "page as a guest" do
    setup do
      _association = association_fixture()
      conn = build_conn()
      category = category_fixture()
      {:ok, conn: conn, category: category}
    end

    test "render show", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      conn = get(conn, Routes.about_page_path(conn, :show, category.title, page.title))
      assert html_response(conn, 200) =~ page.title
    end

    test "new returns access denied", %{conn: conn, category: category} do
      conn = get(conn, Routes.volunteer_category_page_path(conn, :new, category))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "edit returns access denied", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      conn = get(conn, Routes.volunteer_category_page_path(conn, :edit, category, page))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "update returns access denied", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      attrs = update_page_attrs()

      conn =
        put(conn, Routes.volunteer_category_page_path(conn, :update, category, page), page: attrs)

      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "delete returns access denied", %{conn: conn, category: category} do
      page = page_fixture(category.id)
      conn = delete(conn, Routes.volunteer_category_page_path(conn, :delete, category, page))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end
  end
end
