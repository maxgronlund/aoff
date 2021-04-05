defmodule AOFFWeb.ShopAssistant.OrderItemView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  def product_name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      _ -> product.name_en
    end
  end
end
