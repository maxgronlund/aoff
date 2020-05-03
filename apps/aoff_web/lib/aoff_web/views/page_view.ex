defmodule AOFFWeb.PageView do
  use AOFFWeb, :view

  alias AOFF.Shop
  def products_ordered do
    Shop.products_ordered()
  end
end
