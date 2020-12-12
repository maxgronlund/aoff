defmodule AOFFWeb.Volunteer.OrderItemController do
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
    prefix = conn.assigns.prefix

    cond do
      product_id == "" || date_id == "" ->
        error(conn, order_id)

      true ->
        user = Users.get_user!(prefix, user_id)
        product = Shop.get_product!(prefix, product_id)

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

        case Users.add_order_item_to_basket(prefix, pick_up_params, order_item_params) do
          {:ok, %AOFF.Users.OrderItem{}} ->
            conn
            |> put_flash(:info, gettext("%{name} is added to the order", name: product.name_da))
            |> redirect(to: Routes.volunteer_order_path(conn, :edit, order_id))

          _ ->
            conn
            |> put_flash(:error, gettext("Please check date and product"))
            |> redirect(to: Routes.volunteer_order_path(conn, :edit, order_id))
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    order_item = Users.get_order_item!(prefix, id)

    case Users.delete_order_item(prefix, order_item) do
      {:ok, order_item} ->
        conn
        |> put_flash(:info, gettext("Product is removed"))
        |> redirect(to: Routes.volunteer_order_path(conn, :edit, order_item.order))

      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Error"))
        |> redirect(to: Routes.volunteer_order_path(conn, :edit, order_item.order))
    end
  end

  defp error(conn, order_id) do
    conn
    |> put_flash(:error, gettext("Please check date and product"))
    |> redirect(to: Routes.volunteer_order_path(conn, :edit, order_id))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
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
