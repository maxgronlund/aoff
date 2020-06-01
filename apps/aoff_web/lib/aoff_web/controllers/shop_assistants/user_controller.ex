defmodule AOFFWeb.ShopAssistant.UserController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFFWeb.Users.Auth
  alias AOFF.Shop

  plug Auth
  plug :authenticate when action in [:index]

  def index(conn, params) do
    date_id = get_session(conn, :shop_assistant_date_id)
    date = Shop.get_date!(date_id)

    users =
      if query = params["query"] do
        Users.search_users(query)
      else
        page = params["page"] || "0"
        Users.list_users(String.to_integer(page))
      end

    render(conn, "index.html", users: users, pages: Users.user_pages(), date: date)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.shop_assistant do
      assign(conn, :selected_menu_item, :shop)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end