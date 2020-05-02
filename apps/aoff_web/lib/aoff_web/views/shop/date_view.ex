defmodule AOFFWeb.Shop.DateView do
  use AOFFWeb, :view

  alias AOFF.Users
  alias AOFF.Users.Order

  def order_item_params(user_id, product, date_id) do
    %Money{amount: price, currency: :DKK} = product.price

    %{
      "user_id" => user_id,
      "product_id" => product.id,
      "date_id" => date_id,
      "product_name" => product.name,
      "price" => price
    }
  end

  def product_price(product) do
    %Money{amount: price, currency: :DKK} = product.price
    price
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end

  def current_order(user_id) do
    {:ok, %Order{} = order} = Users.current_order(user_id)
    order
  end

  alias AOFF.System

  def host_message() do
    {:ok, message} =
      System.find_or_create_message(
        "/shop/dates/:id - host",
        "For hosts",
        Gettext.get_locale()
      )

    message
  end

  def purchaser_message() do
    {:ok, message} =
      System.find_or_create_message(
        "/shop/dates/:id - purchaser",
        "For purchasers",
        Gettext.get_locale()
      )

    message
  end

  def closed_for_orders_message() do
    {:ok, message} =
      System.find_or_create_message(
        "/shop/dates/:id - closed for orders",
        "Closed for orders",
        Gettext.get_locale()
      )

    message
  end

  def open_for_orders(date) do
    case Date.compare(date.last_order_date, Date.utc_today()) do
      :gt -> true
      :eq -> true
      _ -> false
    end
  end

  def next_opening_date(date) do

  end
end
