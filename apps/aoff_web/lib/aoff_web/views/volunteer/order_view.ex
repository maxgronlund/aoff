defmodule AOFFWeb.Volunteer.OrderView do
  use AOFFWeb, :view

  def payment_state(order) do
    case order.state do
      "payment_accepted" ->
        {:ok, date} = AOFFWeb.Cldr.Date.to_string(order.payment_date, locale: Gettext.get_locale())
        gettext("Payed: %{date}", date: date)
      "payment_declined" ->
        {:ok, date} = AOFFWeb.Cldr.Date.to_string(order.payment_date, locale: Gettext.get_locale())
        gettext("Payment declined: %{date}", date: date)
      "open" ->
        gettext("Basket")
      "cancled" ->
        gettext("Cancled")
      _ -> order.state
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

  def order_nr(order) do
    if is_nil(order.order_nr) do
      ""
    else
      gettext("Order #%{nr}", nr: order.order_nr)
    end
  end

  def open?(state) do
    state == "open"
  end

  def closed?(state) do
    !open?(state)
  end


  def total_exc_vat(total) do
    %Money{amount: amount} = total
    Money.multiply(Money.new(amount, :DKK), 0.8)
  end

  def vat_amount(total) do
    %Money{amount: amount} = total
    Money.multiply(Money.new(amount, :DKK), 0.2)
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
end


