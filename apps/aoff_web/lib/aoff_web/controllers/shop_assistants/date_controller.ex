defmodule AOFFWeb.ShopAssistant.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFFWeb.Users.Auth

  plug Auth
  plug :authenticate when action in [:index, :show]

  @dates_pr_page 8

  def index(conn, params) do


    page =
      case params["page"] do
        nil -> Shop.todays_page(@dates_pr_page)
        page -> String.to_integer(page)
      end

    dates = Shop.list_all_dates(Date.utc_today(), page, @dates_pr_page)
    date = Shop.get_next_date(AOFF.Time.today())

    render(
      conn,
      "index.html",
      dates: dates,
      date: date,
      pages: Shop.date_pages(),
      page: page
    )
  end

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
      assign(conn, :selected_menu_item, :shop)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
