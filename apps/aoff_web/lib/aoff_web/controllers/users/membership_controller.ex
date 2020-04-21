defmodule AOFFWeb.Users.MembershipController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.Order
  alias AOFF.Shop
  alias AOFF.System
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:new, :create]

  def new(conn, %{"user_id" => user_id}) do
    conn = assign(conn, :page, :user)
    date = Shop.get_next_date(Date.utc_today())
    user = Users.get_user!(user_id)
    products = Shop.get_memberships()

    {:ok, message} =
      System.find_or_create_message(
        "/users/:id/membership/new/ - buy new",
        "Buy membership",
        Gettext.get_locale()
      )

    render(
      conn,
      "new.html",
      user: user,
      products: products,
      date: date,
      message: message
    )
  end

  def create(conn, %{"user_id" => user_id, "product_id" => product_id}) do
    user = Users.get_user!(user_id)
    order = Users.current_order(user_id)
    product = Shop.get_product!(product_id)
    date = Shop.get_next_date(Date.utc_today())


    pick_up_params = %{
      "date_id" => date.id,
      "user_id" => user.id,
      "username" => user.username,
      "member_nr" => user.member_nr,
      "order_id" => order.id,
      "email" => user.email
    }

    order_item_params =
      %{
        "order_id" => order.id,
        "date_id" => date.id,
        "user_id" => user.id,
        "product_id" => product.id,
        "price" => product.price
      }


    IO.inspect result = Users.add_membership_to_basket(pick_up_params, order_item_params)


    # case result do
    #   {:ok, %OrderItem{} = order_item} ->
    #     conn
    #     )
    #     |> redirect(to: Routes.shop_checkout_path(conn, :edit, order))

    #   # {:error, reason} ->
    #   #   conn
    #   #   |> put_flash(:error, gettext("Sorry an error occured"))
    #   #   |> redirect(to: Routes.shop_date_path(conn, :show, params["date_id"]))
    # end



    # a pick up date is required
    # date = Shop.get_next_date(Date.utc_today())

    # IO.inspect Users.create_order_item(%{
    #   "state" => "initial",
    #   "order_id" => order.id,
    #   "date_id" => date.id,
    #   "user_id" => user.id,
    #   "product_id" => product.id,
    #   "price" => Money.to_string(product.price)
    # })

    conn
    |> redirect(to: Routes.shop_checkout_path(conn, :edit, order))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end

# with {:ok, order} <- result do
#       query =
#         from p in Product,
#           where: p.membership == true,
#           limit: 1

#       if product = Repo.one(query) do
#         query =
#           from oi in OrderItem,
#             where: oi.order_id == ^order.id and oi.product_id == ^product.id,
#             limit: 1

#         if Repo.one(query) do
#           IO.puts "====== OHEY there was a membership time to extend the users membership"
#         end
#       end
#     end
