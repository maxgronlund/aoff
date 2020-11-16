defmodule AOFFWeb.PageController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Shop
  alias AOFF.Content

  def index(conn, _params) do
    prefix = conn.assigns.prefix

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "/",
        "About AOFF - landing page",
        Gettext.get_locale()
      )

    {:ok, this_weeks_bag} =
      System.find_or_create_message(
        prefix,
        "/",
        "This weeks bag - landing page",
        Gettext.get_locale()
      )

    date = Shop.get_next_date(prefix, AOFF.Time.today())
    products = Shop.get_products_for_landing_page(prefix)
    conn = assign(conn, :backdrop, :show)
    conn = assign(conn, :selected_menu_item, :home)

    render(conn, "index.html",
      products: products,
      date: date,
      message: message,
      this_weeks_bag: this_weeks_bag,
      products_ordered: Shop.products_ordered(prefix),
      featured_pages: Content.featured_pages(prefix)
    )
  end
end
