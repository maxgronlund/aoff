defmodule AOFFWeb.Users.UnsubscribeToNewsControllerTest do
  use AOFFWeb.ConnCase

  alias AOFF.Users

  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  describe "as a member" do
    setup do
      # {:ok, %AOFF.Users.User{} = user} =
      {:ok, %AOFF.Users.User{} = user} =
        user_fixture()
        |> Users.set_unsubscribe_to_news_token()

      conn = build_conn()
      {:ok, conn: conn, user: user}
    end

    test "show/1 unscribe the user to the news letter when the token is valid", %{
      conn: conn,
      user: user
    } do
      conn =
        get(conn, Routes.unsubscribe_to_news_path(conn, :show, user.unsubscribe_to_news_token))

      assert html_response(conn, 200) =~ user.username
      user = Users.get_user(user.id)
      refute user.subscribe_to_news
      refute user.unsubscribe_to_news_token
    end
  end

  describe "as a guest guessing an unsubscribe to newsletter link" do
    test "show/1 returns 401 when there is not user found" do
      conn = build_conn()
      conn = get(conn, Routes.unsubscribe_to_news_path(conn, :show, "bad-token"))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end
  end
end