defmodule AOFFWeb.ShopAssistant.PickUpController do
  use AOFFWeb, :controller

  alias AOFF.Shop

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:show]

  def show(conn, %{"id" => id}) do
    pick_up = Shop.get_pick_up!(id)

    if pick_up.picked_up do
      render(conn, "show.html", pick_up: pick_up)
    else
      Shop.update_pick_up(pick_up, %{"picked_up" => true})

      conn
      |> put_flash(:info, gettext("PickUp updated successfully."))
      |> redirect(to: Routes.shop_assistant_date_path(conn, :show, pick_up.date))
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.shop_assistant do
      assign(conn, :page, :shop)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
