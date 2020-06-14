defmodule AOFFWeb.EmailView do
  use AOFFWeb, :view

  def date(date) do
    if is_nil(date) do
      ""
    else
      {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
      date
    end
  end

  def name(product) do
    case Gettext.get_locale() do
      "da" -> product.name_da
      "en" -> product.name_en
      _ -> product.name_en
    end
  end

  def paymenttype(paymenttype) do
    case paymenttype do
      "1" -> "Dankort/Visa-Dankort"
      "2" -> "MasterCard"
      "3" -> "Visa / Visa Electron"
      "cash" -> gettext("cash")
      _ -> "Betalingskort"
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
