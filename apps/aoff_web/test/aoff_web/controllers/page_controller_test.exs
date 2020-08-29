defmodule AOFFWeb.PageControllerTest do
  use AOFFWeb.ConnCase

  import AOFFWeb.Gettext
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture

  test "GET /", %{conn: conn} do
    _date = date_fixture()
    product = product_fixture()
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ gettext("Become member")
    assert html_response(conn, 200) =~ product.name_da
  end
end
