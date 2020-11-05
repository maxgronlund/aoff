defmodule AOFFWeb.Users.InvoiceController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFFWeb.Users.Auth
  plug Auth

  plug :authenticate when action in [:index, :show]
  plug :navbar when action in [:index, :show]

  def index(conn, %{"user_id" => user_id}) do
    prefix = conn.assigns.prefix
    conn = assign(conn, :selected_menu_item, :user)
    user = get_user!(conn, user_id)
    orders = Users.list_orders(user.id, prefix)
    render(conn, "index.html", user: user, orders: orders)
  end

  def show(conn, %{"id" => id}) do
    order = Users.get_order!(id, conn.assigns.prefix)

    conn =
      case order.state do
        "open" -> assign(conn, :selected_menu_item, :order)
        _ -> assign(conn, :selected_menu_item, :user)
      end

    render(conn, "show.html", user: order.user, order: order)
  end

  def delete(conn, %{"id" => id}) do
    order = Users.get_order!(id, conn.assigns.prefix)
    {:ok, _order} = Users.delete_order(order)

    conn
    |> put_flash(:info, gettext("Order deleted successfully."))
    |> redirect(to: Routes.shop_shop_path(conn, :index))
  end

  defp get_user!(conn, id) do
    user = Users.get_user!(id, conn.assigns.prefix)

    if user do
      authorize(conn, user)
    else
      conn
      |> put_status(404)
      |> put_view(BEWeb.ErrorView)
      |> render(:"404")
      |> halt()
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  defp authorize(conn, user) do
    current_user = conn.assigns.current_user

    if current_user.admin ||
         current_user.volunteer ||
         current_user.id == user.id do
      user
    else
      conn
      |> put_status(403)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"403")
      |> halt()
    end
  end

  defp navbar(conn, _opts) do
    assign(conn, :selected_menu_item, :user)
  end
end
