defmodule AOFFWeb.CommitteeChannel do
  # use AOFFWeb, :channel
  use Phoenix.Channel

  alias AOFF.Chats

  def join("committee:lobby", payload, socket) do
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

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (committee:lobby).
  def handle_in("shout", payload, socket) do
    payload = Map.merge(
      payload,
      %{
        "posted_at" => AOFF.Time.now(),
        "posted" => AOFF.Time.today_as_string()
      }
    )
    {:ok, %AOFF.Chats.Message{id: id}} = Chats.create_message(payload)

    broadcast socket, "shout", Map.put(payload, "id", id)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
