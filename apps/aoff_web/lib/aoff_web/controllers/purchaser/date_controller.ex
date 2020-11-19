defmodule AOFFWeb.Purchaser.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show]

  @dates_pr_page 8

  def index(conn, params) do
    prefix = conn.assigns.prefix

    page =
      case params["page"] do
        nil -> Shop.todays_page(prefix, @dates_pr_page)
        page -> String.to_integer(page)
      end

    dates = Shop.list_all_dates(prefix, Date.utc_today(), page, @dates_pr_page)
    date = Shop.get_next_date(prefix, AOFF.Time.today())

    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("Shoppinglists"))
    |> render(
      "index.html",
      dates: dates,
      date: date,
      pages: Shop.date_pages(),
      page: page
    )
  end

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    date = Shop.get_date!(prefix, id)
    products = Shop.paid_orders_list(prefix, date.id)

    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("Shoppinglist"))
    |> render("show.html", date: date, products: products)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.purchaser do
      assign(conn, :selected_menu_item, :shop)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render("401")
      |> halt()
    end
  end
end
