defmodule AOFFWeb.Users.UnsubscribeToNewsControllerTest do
  use AOFFWeb.ConnCase

  alias AOFF.Users

  import AOFF.Users.UserFixture
  import AOFF.Admin.AssociationFixture
  import AOFFWeb.Gettext

  describe "as a member" do
    setup do
      _association = association_fixture()

      {:ok, %AOFF.Users.User{} = user} =
        user_fixture()
        |> Users.set_unsubscribe_to_news_token()

      conn =
        build_conn()
        |> assign(:prefix, "public")

      {:ok, conn: conn, user: user}
    end

    test "show/1 unscribe the user to the news letter when the token is valid", %{
      conn: conn,
      user: user
    } do
      conn =
        get(conn, Routes.unsubscribe_to_news_path(conn, :show, user.unsubscribe_to_news_token))

      assert html_response(conn, 200) =~ user.username
      user = Users.get_user("public", user.id)
      refute user.subscribe_to_news
      refute user.unsubscribe_to_news_token
    end
  end

  describe "as a guest guessing an unsubscribe to newsletter link" do
    setup do
      _association = association_fixture()

      conn =
        build_conn()
        |> assign(:prefix, "public")

      {:ok, conn: conn}
    end

    test "show/1 returns 401 when there is not user found", %{conn: conn} do
      conn = get(conn, Routes.unsubscribe_to_news_path(conn, :show, "bad-token"))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end
  end
end
