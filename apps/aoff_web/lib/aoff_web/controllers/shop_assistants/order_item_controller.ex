defmodule AOFFWeb.ShopAssistant.OrderItemController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Shop
  alias AOFFWeb.Users.Auth

  plug Auth
  plug :authenticate when action in [:create]

  def create(
        conn,
        %{
          "order_id" => order_id,
          "order_item" => %{
            "date_id" => date_id,
            "order_id" => order_id,
            "product_id" => product_id,
            "user_id" => user_id
          }
        }
      ) do
    cond do
      product_id == "" || date_id == "" ->
        error(conn, user_id)

      true ->
        user = Users.get_user!(user_id)
        product = Shop.get_product!(product_id)

        pick_up_params = %{
          "date_id" => date_id,
          "user_id" => user_id,
          "order_id" => order_id,
          "username" => user.username,
          "member_nr" => user.member_nr,
          "email" => user.email
        }

        order_item_params = %{
          "order_id" => order_id,
          "date_id" => date_id,
          "user_id" => user_id,
          "product_id" => product_id,
          "price" => product.price
        }

        case Users.add_order_item_to_basket(pick_up_params, order_item_params) do
          {:ok, %AOFF.Users.OrderItem{}} ->
            conn
            |> put_flash(:info, gettext("%{name} is added to the order", name: product.name_da))
            |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, user))

          _ ->
            conn
            |> put_flash(:error, gettext("Please check date and product"))
            |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, user))
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item = Users.get_order_item!(id)

    case Users.delete_order_item(order_item) do
      {:ok, order_item} ->
        conn
        |> put_flash(:info, gettext("Product is removed"))
        |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, order_item.order.user))

      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Error"))
        |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, order_item.order.user))
    end
  end

  defp error(conn, user_id) do
    conn
    |> put_flash(:error, gettext("Please check date and product"))
    |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, user_id))
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
