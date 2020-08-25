defmodule AOFFWeb.Content.CalendarControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.PageFixture
  import AOFF.Users.UserFixture
  import AOFF.Content.CategoryFixture
  import AOFFWeb.Gettext
  alias Plug.Conn

  describe "calendar as a guest" do
    test "render index", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      conn = get(conn, Routes.calendar_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Calendar")
    end

    test "render show", %{conn: conn} do
      category = category_fixture(%{"identifier" => "Calendar", "title" => "Calendar"})
      page = page_fixture(category.id)
      conn = get(conn, Routes.calendar_path(conn, :show, page.title))
      assert html_response(conn, 200) =~ page.title
    end
  end
end