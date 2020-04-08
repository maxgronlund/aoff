defmodule AOFFWeb.Users.OrderController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.Order
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show]
  plug :navbar when action in [:index, :show]

  def index(conn, %{"user_id" => user_id}) do
    conn = assign(conn, :page, :user)
    user = get_user!(conn, user_id)
    orders = Users.list_orders(user.id)
    render(conn, "index.html", user: user, orders: orders)
  end

  def show(conn, %{"id" => id}) do

    order = Users.get_order!(id)
    conn =
      case order.state do
        "open" -> assign(conn, :page, :order)
        _ -> assign(conn, :page, :user)
      end

    render(conn, "show.html", user: order.user, order: order)
  end

  defp get_user!(conn, id) do
    user = Users.get_user!(id)

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
    conn = assign(conn, :page, :user)
  end
end
