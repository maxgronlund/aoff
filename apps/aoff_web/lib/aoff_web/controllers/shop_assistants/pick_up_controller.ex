defmodule AOFFWeb.ShopAssistant.PickUpController do
  use AOFFWeb, :controller

  alias AOFF.Shop

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:show, :index]

  @dates_pr_page 12

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    pick_up = Shop.get_pick_up!(prefix, id)

    if pick_up.picked_up do
      render(conn, "show.html", pick_up: pick_up)
    else
      Shop.update_pick_up(pick_up, %{"picked_up" => true})

      conn
      |> put_flash(:info, gettext("PickUp updated successfully."))
      |> redirect(to: Routes.shop_assistant_date_path(conn, :show, pick_up.date))
    end
  end

  def index(conn, params) do
    prefix = conn.assigns.prefix

    page =
      case params["page"] do
        nil -> Shop.todays_page(prefix, @dates_pr_page)
        page -> String.to_integer(page)
      end

    dates = Shop.list_all_dates(prefix, AOFF.Time.today(), page, @dates_pr_page)
    date = Shop.get_next_date(prefix, AOFF.Time.today())

    render(
      conn,
      "index.html",
      dates: dates,
      date: date,
      pages: Shop.date_pages(prefix),
      page: page
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
