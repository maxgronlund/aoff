defmodule AOFFWeb.ShopAssistant.PickUpController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.Shop.PickUp

  def show(conn, %{"id" => id}) do
    pick_up = Shop.get_pick_up!(id)

    if pick_up.picked_up do
      render(conn, "show.html", pick_up: pick_up)
    else
      Shop.update_pick_up(pick_up, %{"picked_up" => true})

      conn
      |> put_flash(:info, "PickUp updated successfully.")
      |> redirect(to: Routes.shop_assistant_date_path(conn, :show, pick_up.date))
    end
  end
end
