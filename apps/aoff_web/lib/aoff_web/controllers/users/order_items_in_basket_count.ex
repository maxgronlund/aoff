defmodule AOFFWeb.Users.OrderItemsInBasketCount do
  import Plug.Conn

  alias AOFF.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    order_items_count =
      if user = conn.assigns.current_user do
        Users.order_items_count(user.id)
      else
        false
      end

    conn
    |> assign(:order_items_count, order_items_count)
  end

end