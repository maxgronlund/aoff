defmodule AOFFWeb.PageController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Shop
  alias AOFF.Blogs


  def index(conn, _params) do
    {:ok, message} =
      System.find_or_create_message(
        "/",
        "About AOFF - landing page",
        Gettext.get_locale()
      )


    {:ok, this_weeks_bag} =
      System.find_or_create_message(
        "/",
        "This weeks bag - landing page",
        Gettext.get_locale()
      )


    date = Shop.get_next_date(AOFF.Time.today())
    products = Shop.get_products_for_landing_page()
    blog_posts = Blogs.get_landing_page_posts()
    conn = assign(conn, :backdrop, :show)
    conn = assign(conn, :page, :home)
    render(conn, "index.html",
      products: products,
      date: date,
      message: message,
      blog_posts: blog_posts,
      this_weeks_bag: this_weeks_bag,
      products_ordered: Shop.products_ordered()
    )
  end
end
