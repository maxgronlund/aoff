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
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  def current_order(user_id, prefix) do
    {:ok, %Order{} = order} = Users.current_order(user_id, prefix)
    order
  end

  alias AOFF.System

  def closed_for_orders_message(prefix) do
    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "/shop/dates/:id - closed for orders",
        "Closed for orders",
        Gettext.get_locale()
      )

    message
  end

  def name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      "en" -> product.name_en
      _ -> product.name_en
    end
  end

  def description(product) do
    case Gettext.get_locale() do
      "da" -> product.description_da
      "en" -> product.description_en
      _ -> product.description_en
    end
  end

  def this_weeks_content(product) do
    case Gettext.get_locale() do
      "da" -> product.this_weeks_content_da
      "en" -> product.this_weeks_content_en
      _ -> product.this_weeks_content_en
    end
  end
end
