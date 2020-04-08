defmodule AOFFWeb.Admin.AdminController do
  use AOFFWeb, :controller

  plug BasicAuth, use_config: {:aoff_web, :basic_auth}

  alias AOFF.Users

  def index(conn, _params) do
    users = Users.list_users()

    render(conn, "index.html", users: users)
  end
end
