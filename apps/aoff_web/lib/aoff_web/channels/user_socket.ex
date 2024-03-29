defmodule AOFFWeb.UserSocket do
  use Phoenix.Socket

  # channel "ping" AOFFWeb.PingChannel

  # def connect(_params, socket, _connect_info) do
  #   {:ok, socket}
  # end

  ## Channels
  # TODO: replace with live view
  channel "shop:date", AOFFWeb.ShopChannel
  channel "pick:up", AOFFWeb.PickUpChannel

  # channel "room:*", AOFFWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  # def connect(_params, socket, _connect_info) do
  #   {:ok, socket}
  # end

  # max_age: 1209600 is equivalent to two weeks in seconds
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user, user_id)}

      {:error, _reason} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     AOFFWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
