defmodule AOFFWeb.Shop.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.System

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :shop)
    date = Shop.get_date!(id)
    products = Shop.list_products(:for_sale)


    unless conn.assigns.valid_member do
      {:ok, expired_message } = System.find_or_create_message("/shop/ - expired", Gettext.get_locale())
      {:ok, login_message } = System.find_or_create_message("/shop/ - login", Gettext.get_locale())
      render(
        conn,
        "show.html",
        expired_message: expired_message,
        login_message: login_message,
        date: date,
        products: products
      )
    else
      render(conn, "show.html", date: date, products: products)
    end
  end

  # def index(conn, _params) do
  #   for year <- 2020..2029, month <- 1..11, date <- 1..31 do
  #     case Date.new(year, month, date) do
  #       {:ok, date} ->
  #         if Date.day_of_week(date) == 3 do
  #           if Date.compare(date, Date.utc_today()) == :gt do
  #             Shop.create_date(%{
  #               "date" => date
  #             })
  #           end
  #         end

  #       _ ->
  #         "not a date"
  #     end
  #   end

  #   render(conn, "index.html")
  # end
end
