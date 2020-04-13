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
    {:ok, message } = System.find_or_create_message("/shop/dates/:id - host", Gettext.get_locale())

    message
  end
  def purchaser_message() do
    {:ok, message } = System.find_or_create_message("/shop/dates/:id - purchaser", Gettext.get_locale())

    message
  end
end
