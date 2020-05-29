defmodule AOFFWeb.Volunteers.NewsControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Content.NewsFixture
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

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

      {:ok, conn: conn}
    end

    test "new news renders form", %{conn: conn} do
      conn = get(conn, Routes.volunteer_news_path(conn, :new))
      assert html_response(conn, 200) =~ gettext("New News")
    end

    test "create news redirects to edit when data is valid", %{conn: conn} do
      attrs = create_news_attrs()
      conn = post(conn, Routes.volunteer_news_path(conn, :create), news: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_news_path(conn, :edit, id)

      conn = get(conn, Routes.news_path(conn, :show, id))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "create news renders errors when data is invalid", %{conn: conn} do
      attrs = invalid_news_attrs()
      conn = post(conn, Routes.volunteer_news_path(conn, :create), news: attrs)
      assert html_response(conn, 200) =~ gettext("New News")
    end

    test "edit news renders form for editing chosen news", %{conn: conn} do
      news = news_fixture()
      conn = get(conn, Routes.volunteer_news_path(conn, :edit, news))
      assert html_response(conn, 200) =~ gettext("Edit News")
    end

    test "update news redirects when data is valid", %{conn: conn} do
      news = news_fixture()
      attrs = update_news_attrs()
      conn = put(conn, Routes.volunteer_news_path(conn, :update, news), news: attrs)
      assert redirected_to(conn) == Routes.news_path(conn, :show, news)

      conn = get(conn, Routes.news_path(conn, :show, news))
      assert html_response(conn, 200) =~ attrs["title"]
    end

    test "update news renders errors when data is invalid", %{conn: conn} do
      news = news_fixture()
      attrs = invalid_news_attrs()
      conn = put(conn, Routes.volunteer_news_path(conn, :update, news), news: attrs)
      assert html_response(conn, 200) =~ gettext("Edit News")
    end

    test "deletes chosen news", %{conn: conn} do
      news = news_fixture()
      conn = delete(conn, Routes.volunteer_news_path(conn, :delete, news))
      assert redirected_to(conn) == Routes.news_path(conn, :index)

    end
  end
end
