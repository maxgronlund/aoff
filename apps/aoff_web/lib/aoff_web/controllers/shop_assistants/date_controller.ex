defmodule AOFFWeb.ShopAssistant.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.Users

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:show]

  def show(conn, params) do

    date = Shop.get_date!(params["id"])
    query = params["query"]

    pick_ups =
      if query do
        Shop.search_pick_up(query, params["id"])
      else
        Shop.list_pick_ups(date.id)
      end

    render(
      conn,
      "show.html",
      date: date,
      pick_ups: pick_ups
    )
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.shop_assistant do
      assign(conn, :page, :shop)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
