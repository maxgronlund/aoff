defmodule AOFFWeb.Content.AboutControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.Content.CategoryFixture
  import AOFF.Admin.AssociationFixture
  alias AOFF.System

  describe "guest" do
    setup do
      _association = association_fixture()

      conn =
        build_conn()
        |> assign(:prefix, "public")

      {:ok, conn: conn}
    end

    test "show all categories", %{conn: conn} do
      {:ok, message} =
        System.find_or_create_message(
          "public",
          "/info",
          "Info",
          Gettext.get_locale()
        )

      conn = get(conn, Routes.about_path(conn, :index))
      assert html_response(conn, 200) =~ message.title
    end

    test "show category", %{conn: conn} do
      category = category_fixture()
      # page = page_fixture(category.id)
      conn = get(conn, Routes.about_path(conn, :show, category.title))
      assert html_response(conn, 200) =~ category.title
    end
  end
end
