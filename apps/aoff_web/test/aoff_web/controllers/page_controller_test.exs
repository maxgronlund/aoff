defmodule AOFFWeb.PageControllerTest do
  use AOFFWeb.ConnCase

  import AOFFWeb.Gettext

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ gettext("Become member")
  end
end
