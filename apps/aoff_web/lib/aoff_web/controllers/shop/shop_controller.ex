defmodule AOFFWeb.Shop.ShopController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.System

  plug :navbar when action in [:index]

  def index(conn, _params) do
    prefix = conn.assigns.prefix
    dates = Shop.list_dates(AOFF.Time.today(), prefix, 0, 6)

    unless conn.assigns.valid_member do
      {:ok, expired_message} =
        System.find_or_create_message(
          "/shop/ - expired",
          "Membership expired",
          Gettext.get_locale(),
          prefix
        )

      {:ok, login_message} =
        System.find_or_create_message(
          "/shop/ - login",
          "Login to shop",
          Gettext.get_locale(),
          prefix
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

  defp navbar(conn, _opts) do
    conn
    |> assign(:selected_menu_item, :shop)
    |> assign(:title, gettext("Shop"))
  end
end
