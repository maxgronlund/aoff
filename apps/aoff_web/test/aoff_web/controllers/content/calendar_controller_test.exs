defmodule AOFFWeb.Content.CalendarControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.PageFixture
  import AOFF.Content.CategoryFixture
  import AOFF.Admin.AssociationFixture
  import AOFFWeb.Gettext

  describe "calendar as a guest" do
    setup do
      _association = association_fixture()
      conn =
        build_conn()
        |> assign(:prefix, "public")
      {:ok, conn: conn}
    end

    test "render index", %{conn: conn} do
      _category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      conn = get(conn, Routes.calendar_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Calendar")
    end

    test "render show", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      page = page_fixture(category.id)
      conn = get(conn, Routes.calendar_path(conn, :show, page.title))
      assert html_response(conn, 200) =~ page.title
    end

    test "new returns access denied", %{conn: conn} do
      conn = get(conn, Routes.volunteer_calendar_path(conn, :new))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "edit returns access denied", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      page = page_fixture(category.id)
      conn = get(conn, Routes.volunteer_calendar_path(conn, :edit, page))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "update returns access denied", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      page = page_fixture(category.id)
      attrs = update_page_attrs()
      conn = put(conn, Routes.volunteer_calendar_path(conn, :update, page), page: attrs)

      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "delete returns access denied", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      page = page_fixture(category.id)
      conn = delete(conn, Routes.volunteer_calendar_path(conn, :delete, page.id))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end
  end
end
