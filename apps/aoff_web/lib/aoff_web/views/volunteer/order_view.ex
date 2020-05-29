defmodule AOFFWeb.Volunteer.OrderView do
  use AOFFWeb, :view

  def payment_state(order) do
    case order.state do
      "payment_accepted" ->
        {:ok, date} = AOFFWeb.Cldr.Date.to_string(order.payment_date, locale: Gettext.get_locale())
        gettext("Paied: %{date}", date: date)
      "payment_declined" ->
        {:ok, date} = AOFFWeb.Cldr.Date.to_string(order.payment_date, locale: Gettext.get_locale())
        gettext("Payment declined: %{date}", date: date)
      _ -> ""
    end
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

  def open?(state) do
    case state do
      "open" -> true
      _ -> false
    end
  end

  def closed?(state) do
    !open?(state)
  end
end


