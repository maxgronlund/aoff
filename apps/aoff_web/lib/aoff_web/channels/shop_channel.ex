defmodule AOFFWeb.ShopChannel do
  use Phoenix.Channel

  def join("shop:date", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  alias AOFF.Users
  alias AOFF.Shop

  def handle_in("add_to_basked", payload, socket) do
    #TODO: find host and convert to prefix
    prefix = payload["prefix"]

    user = Users.get_user!(payload["user_id"], prefix)
    order = Users.current_order(payload["user_id"], prefix)
    product = Shop.get_product!(payload["product_id"], prefix)

    pick_up_params = %{
      "date_id" => payload["date_id"],
      "user_id" => user.id,
      "username" => user.username,
      "member_nr" => user.member_nr,
      "order_id" => order.id,
      "email" => user.email
    }

    order_item_params =
      payload
      |> Map.merge(%{
        "price" => product.price,
        "order_id" => order.id
      })

    Users.add_order_item_to_basket(pick_up_params, order_item_params, prefix)

    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic.
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
