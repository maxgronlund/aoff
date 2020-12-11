defmodule AOFFWeb.ShopAssistant.OrderItemController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.OrderItem
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
        error(conn, user_id)

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
            |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, user))

          _ ->
            conn
            |> put_flash(:error, gettext("Please check date and product"))
            |> redirect(to: Routes.shop_assistant_user_order_path(conn, :new, user))
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    case  Users.get_order_item!(prefix, id) do
      %OrderItem{} = order_item ->

        changeset = Users.change_order_item(order_item)
        render(
          conn,
          "edit.html",
          order_item: order_item,
          changeset: changeset,
          dates: dates(prefix)
        )
      _ ->
        render(conn, "not_found.html")
    end
  end

  defp dates(prefix) do
    dates = Shop.list_dates(prefix, Date.add(AOFF.Time.today(), -7), 0, 7)
    Enum.map(dates, fn x -> {AOFF.Time.date_as_string(x.date), x.id} end)
  end

  def update(conn, %{ "id" => id, "order_item" => params}) do
    prefix = conn.assigns.prefix

    order_item = Users.get_order_item!(prefix, id)
    prev_pick_up = order_item.pick_up
    # prev_pick_up = order_item.pick_up_id

    pickup_params =
      %{
          "date_id" => params["date_id"],
          "user_id" => params["user_id"],
          "order_id" => params["order_id"],
          "username" => order_item.order.user.username,
          "member_nr" => order_item.order.user.member_nr,
          "email" => order_item.order.user.email
        }
    {:ok, pick_up} = Shop.find_or_create_pick_up(prefix, pickup_params)

    params = Map.put(params, "pick_up_id", pick_up.id)
    Users.move_order_item_pick_up_date(order_item, params)
    conn
    |> redirect(to: Routes.shop_assistant_pick_up_path(conn, :edit, prev_pick_up))

  end

  def delete(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    order_item = Users.get_order_item!(prefix, id)



    case Users.delete_order_item(prefix, order_item) do
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
