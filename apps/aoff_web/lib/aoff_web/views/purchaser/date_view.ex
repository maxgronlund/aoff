defmodule AOFFWeb.Purchaser.DateView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date_as_string} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")

    case Date.compare(date, AOFF.Time.today()) do
      :lt ->
        "<div class=\"is-gray\">#{date_as_string}</div>"

      _ ->
        "<b>#{date_as_string}</b>"
    end
  end

  def date_as_string(date) do
    {:ok, date_as_string} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date_as_string
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
