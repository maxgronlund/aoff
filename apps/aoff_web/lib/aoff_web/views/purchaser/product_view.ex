defmodule AOFFWeb.Purchaser.ProductView do
  use AOFFWeb, :view

  def for_sale(for_sale) do
    if for_sale, do: gettext("Show in shop √"), else: gettext("Hidden")
  end

  def show_on_landing_page(show_on_landing_page) do
    if show_on_landing_page, do: gettext("Show on landing page √"), else: ""
  end
end
