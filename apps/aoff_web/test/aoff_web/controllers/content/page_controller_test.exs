defmodule AOFFWeb.Content.PageControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.PageFixture
  import AOFF.Content.CategoryFixture
  # import AOFF.Blogs.CategoryFixture
  # import AOFF.Content.NewsFixture

  # alias AOFF.Volunteer

  alias AOFF.System

  describe "guest" do
    test "show page", %{conn: conn} do
      category = category_fixture()
      page = page_fixture(category.id)
      conn = get(conn, Routes.about_page_path(conn, :show, category.title, page.title))
      assert html_response(conn, 200) =~ page.title
    end
  end
end
