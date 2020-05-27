defmodule AOFFWeb.PageControllerTest do
  use AOFFWeb.ConnCase

  import AOFFWeb.Gettext
  import AOFF.Shop.DateFixture
  import AOFF.Shop.ProductFixture
  import AOFF.Content.NewsFixture

  test "GET /", %{conn: conn} do
    _date = date_fixture()
    product = product_fixture()
    news = news_fixture()
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ gettext("Become member")
    assert html_response(conn, 200) =~ product.name_da
    assert html_response(conn, 200) =~ news.title
  end
end
