defmodule AOFFWeb.ShopAssistant.ShopAssistantController do
  use AOFFWeb, :controller

  alias AOFF.Shop

  def index(conn, _params) do
    dates = Shop.list_dates(Date.utc_today())
    render(conn, "index.html", dates: dates)
  end
end
