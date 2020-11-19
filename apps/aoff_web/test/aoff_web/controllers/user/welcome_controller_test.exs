defmodule AOFFWeb.Users.WelcomeControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  test "show welcome page", %{conn: conn} do
    user = user_fixture()
    conn = conn.assign(prefix: "public")
    conn = get(conn, Routes.user_welcome_path(conn, :index, user))
    assert html_response(conn, 200) =~ gettext("Welcome")
  end
end
