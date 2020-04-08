defmodule AOFFWeb.ShopAssistant.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop

  def show(conn, params) do
    conn = assign(conn, :page, :shop_assistant)
    date = Shop.get_date!(params["id"])
    query = params["query"]

    pick_ups =
      if query do
        Shop.search_pick_up(query, params["id"])
      else
        Shop.list_pick_ups(date.id)
      end

    render(conn, "show.html", date: date, pick_ups: pick_ups)
  end
end
