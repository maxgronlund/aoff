defmodule AOFFWeb.Content.NewsControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.NewsFixture
  import AOFFWeb.Gettext

  describe "guest" do
    test "lists all news", %{conn: conn} do
      conn = get(conn, Routes.news_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing News")
    end

    test "show news", %{conn: conn} do
      news = news_fixture()
      conn = get(conn, Routes.news_path(conn, :show, news.id))
      assert html_response(conn, 200) =~ news.title
    end
  end

  # describe "volunteer" do
  #   test "lists all news", %{conn: conn} do
  #     conn = get(conn, Routes.news_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Listing News"
  #   end

  #   test "new news renders form", %{conn: conn} do
  #     conn = get(conn, Routes.news_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New News"
  #   end

  #   test "create news redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.news_path(conn, :create), news: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.news_path(conn, :show, id)

  #     conn = get(conn, Routes.news_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show News"
  #   end

  #   test "create news renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.news_path(conn, :create), news: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New News"
  #   end

  #   test "edit news renders form for editing chosen news", %{conn: conn, news: news} do
  #     conn = get(conn, Routes.news_path(conn, :edit, news))
  #     assert html_response(conn, 200) =~ "Edit News"
  #   end

  #   test "update news redirects when data is valid", %{conn: conn, news: news} do
  #     conn = put(conn, Routes.news_path(conn, :update, news), news: @update_attrs)
  #     assert redirected_to(conn) == Routes.news_path(conn, :show, news)

  #     conn = get(conn, Routes.news_path(conn, :show, news))
  #     assert html_response(conn, 200) =~ "some updated author"
  #   end

  #   test "update news renders errors when data is invalid", %{conn: conn, news: news} do
  #     conn = put(conn, Routes.news_path(conn, :update, news), news: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit News"
  #   end

  #   test "deletes chosen news", %{conn: conn, news: news} do
  #     conn = delete(conn, Routes.news_path(conn, :delete, news))
  #     assert redirected_to(conn) == Routes.news_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.news_path(conn, :show, news))
  #     end
  #   end
  # end
end
