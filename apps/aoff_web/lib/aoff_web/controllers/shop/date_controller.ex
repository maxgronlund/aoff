defmodule AOFFWeb.Shop.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.System

  plug :navbar when action in [:show]

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    date = Shop.get_date!(prefix, id)
    products = Shop.list_products(prefix, :for_sale)

    unless conn.assigns.valid_member do
      prefix = conn.assigns.prefix

      {:ok, expired_message} =
        System.find_or_create_message(
          prefix,
          "/shop/ - expired",
          "Membership inactive",
          Gettext.get_locale()
        )

      {:ok, login_message} =
        System.find_or_create_message(
          prefix,
          "/shop/ - login",
          "Login to buy products",
          Gettext.get_locale()
        )

      render(
        conn,
        "show.html",
        expired_message: expired_message,
        login_message: login_message,
        date: date,
        products: products,
        products_ordered: products_ordered(date)
      )
    else
      render(conn, "show.html",
        date: date,
        products: products,
        products_ordered: products_ordered(date)
      )
    end
  end

  defp products_ordered(date) do
    case Elixir.Date.compare(AOFF.Time.today(), date.last_order_date) do
      :gt -> true
      _ -> false
    end
  end

  defp navbar(conn, _opts) do
    conn
    |> assign(:selected_menu_item, :shop)
    |> assign(:title, gettext("Shop"))
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
