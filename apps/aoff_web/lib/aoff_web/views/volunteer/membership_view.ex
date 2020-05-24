defmodule AOFFWeb.Volunteer.MembershipView do
  use AOFFWeb, :view

  def for_sale(for_sale) do
    if for_sale, do: gettext("Show in shop √"), else: gettext("Hidden")
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
end
