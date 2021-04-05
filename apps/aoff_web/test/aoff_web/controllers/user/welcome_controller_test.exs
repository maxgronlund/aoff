defmodule AOFFWeb.Users.WelcomeControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture
  import AOFF.Admin.AssociationFixture
  import AOFFWeb.Gettext

  test "show welcome page", %{conn: conn} do
    _association = association_fixture()
    user = user_fixture()
    conn = assign(conn, :prefix, "public")
    conn = get(conn, Routes.user_welcome_path(conn, :index, user))
    assert html_response(conn, 200) =~ gettext("Welcome")
  end
end
