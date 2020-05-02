defmodule AOFFWeb.Shop.ShopView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end



  def open_for_orders(date) do
    case Date.compare(date.last_order_date, Date.utc_today()) do
      :gt -> true
      :eq -> true
      _ -> true
    end
  end
end
