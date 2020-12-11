defmodule AOFFWeb.ShopAssistant.OrderItemView do
  use AOFFWeb, :view
  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end
end