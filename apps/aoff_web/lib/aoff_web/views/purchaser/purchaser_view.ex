defmodule AOFFWeb.Purchaser.PurchaserView do
  use AOFFWeb, :view

  def for_sale(for_sale) do
    if for_sale do
      "√"
    else
      ""
    end
  end
end
