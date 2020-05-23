defmodule AOFFWeb.Shop.CheckoutView do
  use AOFFWeb, :view

  def amount(total) do
    %Money{amount: amount, currency: _currency} = total
    amount
  end

  def name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      "en" -> product.name_en
      _ -> product.name_en
    end
  end
end
