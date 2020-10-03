defmodule AOFF.Volunteer.ShopController do
  use AOFFWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end


end