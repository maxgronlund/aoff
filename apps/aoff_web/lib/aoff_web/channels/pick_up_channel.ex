defmodule AOFFWeb.PickUpChannel do
  use Phoenix.Channel

  alias AOFF.System

  def join("pick:up", payload, socket) do
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

  alias AOFF.Shop

  def handle_in("handled", payload, socket) do

    IO.inspect payload
    IO.inspect socket

    pick_up = Shop.get_pick_up!(payload["pick_up_id"])
    Shop.update_pick_up(pick_up, %{"picked_up" => true})

    {:reply, {:ok, payload}, socket}
  end

  def handle_in("send_sms_reminder", payload, socket) do
    pick_up = Shop.get_pick_up!(payload["pick_up_id"])

    Shop.update_pick_up(pick_up, %{"send_sms_notification" => false})

    user = pick_up.user
    mobile = String.replace(user.mobile_country_code <> user.mobile, " ", "")

    {:ok, pickup_message} =
      System.find_or_create_message(
        "/channels/pickup_channel",
        "Hi USERNAME. Remember to pickup your order today before 6 PM",
        Gettext.get_locale(),
        "public"
      )

    params = %{
      "mobile" => mobile,
      "text" => pickup_message
    }

    AOFF.SMSApi.send_sms_message(params)

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
