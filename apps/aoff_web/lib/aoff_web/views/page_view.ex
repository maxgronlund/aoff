defmodule AOFFWeb.PageView do
  use AOFFWeb, :view

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
