defmodule AOFFWeb.Shop.ShopView do
  use AOFFWeb, :view

  alias AOFF.Time

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end

  def products_ordered(date) do
    case Elixir.Date.compare(Time.today(), date.last_order_date) do
      :gt -> true
      _ -> false
    end
  end
end
