defmodule AOFFWeb.ShopAssistant.PickUpView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  def formatted_date(date) do
    {:ok, date_as_string} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())

    case Date.compare(date, AOFF.Time.today()) do
      :lt ->
        "<div class=\"is-gray\">#{date_as_string}</div>"

      _ ->
        "<b>#{date_as_string}</b>"
    end
  end

  def name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      "en" -> product.name_en
      _ -> product.name_en
    end
  end
end
