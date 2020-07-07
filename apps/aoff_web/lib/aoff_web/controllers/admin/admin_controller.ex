defmodule AOFFWeb.Admin.AdminController do
  use AOFFWeb, :controller

  # plug BasicAuth, use_config: {:aoff_web, :basic_auth}

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
