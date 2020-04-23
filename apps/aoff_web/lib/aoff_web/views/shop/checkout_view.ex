defmodule AOFFWeb.Shop.CheckoutView do
  use AOFFWeb, :view

  def amount(total) do
    %Money{amount: amount, currency: _currency} = total
    amount
  end
end
