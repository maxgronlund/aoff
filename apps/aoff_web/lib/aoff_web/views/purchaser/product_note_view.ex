defmodule AOFFWeb.Purchaser.ProductNoteView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date_as_string} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date_as_string
  end

  def name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      "en" -> product.name_en
      _ -> product.name_en
    end
  end

end
