defmodule AOFFWeb.ShopAssistant.UserController do
  use AOFFWeb, :controller

  alias AOFF.Users
  def index(conn, _params) do

    users = Users.list_users()
    render(conn, "index.html", users: users)
  end
end