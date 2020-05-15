defmodule AOFFWeb.PageControllerTest do
  use AOFFWeb.ConnCase

  import AOFFWeb.Gettext
  import AOFF.Shop.DateFixture

  test "GET /", %{conn: conn} do
    _date = date_fixture()
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ gettext("Become member")
  end
end
