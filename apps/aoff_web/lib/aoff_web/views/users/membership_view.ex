defmodule AOFFWeb.Users.MembershipView do
  use AOFFWeb, :view

  alias AOFF.Users
  alias AOFF.Users.Order

  def current_order_id(user_id) do
    {:ok, %Order{} = order} = Users.current_order(user_id)
    order.id
  end

  def order_item_params(user_id, product, date_id) do
    %{
      "user_id" => user_id,
      "product_id" => product.id,
      "date_id" => date_id,
      "order_id" => current_order_id(user_id),
      "product_name" => product.name
    }
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
