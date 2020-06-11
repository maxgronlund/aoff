defmodule AOFFWeb.Users.InvoiceView do
  use AOFFWeb, :view

  def open?(state) do
    case state do
      "open" -> true
      _ -> false
    end
  end

  def closed?(state) do
    !open?(state)
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  def name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      "en" -> product.name_en
      _ -> product.name_en
    end
  end

  def total_exc_vat(total) do
    %Money{amount: amount} = total
    Money.multiply(Money.new(amount, :DKK), 0.8)
  end

  def vat_amount(total) do
    %Money{amount: amount} = total
    Money.multiply(Money.new(amount, :DKK), 0.2)
  end
end
