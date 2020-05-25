defmodule AOFFWeb.Shop.ShopController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.System

  def index(conn, _params) do
    conn = assign(conn, :selected_menu_item, :shop)
    dates = Shop.list_dates(AOFF.Time.today(), 0, 4)

    unless conn.assigns.valid_member do
      {:ok, expired_message} =
        System.find_or_create_message(
          "/shop/ - expired",
          "Membership expired",
          Gettext.get_locale()
        )

      {:ok, login_message} =
        System.find_or_create_message(
          "/shop/ - login",
          "Login to shop",
          Gettext.get_locale()
        )

      render(
        conn,
        "index.html",
        dates: dates,
        expired_message: expired_message,
        login_message: login_message
      )
    else
      render(conn, "index.html", dates: dates)
    end
  end
end
