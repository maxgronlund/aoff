defmodule AOFFWeb.Purchaser.ProductView do
  use AOFFWeb, :view

  def for_sale(for_sale) do
    if for_sale, do: gettext("Show in shop √"), else: gettext("Hidden")
  end

  def show_on_landing_page(show_on_landing_page) do
    if show_on_landing_page, do: gettext("Show on landing page √"), else: ""
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
