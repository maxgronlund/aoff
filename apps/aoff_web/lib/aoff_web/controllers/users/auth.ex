defmodule AOFFWeb.Users.Auth do
  import Plug.Conn

  alias AOFF.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    prefix = conn.assigns.prefix
    user_id = get_session(conn, :user_id)
    user = user_id && Users.get_user(prefix, user_id)

    conn
    |> assign(:current_user, user)
    |> assign(:valid_member, user && valid_member?(user))
    |> assign(:admin, user && user.admin)
    |> assign(:volunteer, user && user.volunteer)
    |> assign(:purchaser, user && user.purchasing_manager)
    |> assign(:shop_assistant, user && user.shop_assistant)
    |> assign(:text_editor, user && user.text_editor)
    |> assign(:manage_membership, user && user.manage_membership)
    |> assign(:current_order, user && Users.current_order(prefix, user_id))
    |> assign(:order_items_count, user && Users.order_items_count(prefix, user_id))
  end

  def login(conn, user) do
    # if Users.current_order(user.id, ) == nil do
    #   Users.create_order(%{"user_id" => user.id})
    # end

    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_email_and_pass(prefix, conn, email, given_pass) do
    case Users.authenticate_by_email_and_pass(prefix, email, given_pass) do
      {:ok, user} -> validate_confirmation(user, conn)
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {:error, :not_found} -> {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def validate_confirmation(user, conn) do
    cond do
      user.confirmed_at ->
        {:ok, login(conn, user)}

      true ->
        {:error, :confirmation_missing, conn}
    end
  end

  defp valid_member?(user) do
    if user.expiration_date == nil do
      false
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> true
        :lt -> false
        :eq -> true
      end
    end
  end
end
