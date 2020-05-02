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


  # %{
  #     "date_id" => "41f6fcb9-b87f-4c74-a553-0023deeaafd0",
  #     "price" => "2300",
  #     "product_id" => "1a75f882-e3ba-4815-b46f-467472329258",
  #     "product_name" => "30 æg",
  #     "user_id" => "c64035c8-3c91-4c81-8993-d03b4b9b396c"
  # }

  def handle_in("add_to_basked", payload, socket) do

    user = Users.get_user!(payload["user_id"])
    order = Users.current_order(payload["user_id"])
    product = Shop.get_product!(payload["product_id"])



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

    Users.add_order_item_to_basket(pick_up_params, order_item_params)



    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (committee:lobby).
  def handle_in("shout", payload, socket) do



    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end