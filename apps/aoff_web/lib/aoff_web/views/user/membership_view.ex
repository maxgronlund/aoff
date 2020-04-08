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
end
