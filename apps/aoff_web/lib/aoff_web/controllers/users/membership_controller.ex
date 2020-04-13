defmodule AOFFWeb.Users.MembershipController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Shop
  alias AOFF.System

  def new(conn, %{"user_id" => user_id}) do
    conn = assign(conn, :page, :user)
    date = Shop.get_next_date(Date.utc_today())
    user = Users.get_user!(user_id)
    products = Shop.get_memberships()

    {:ok, message } =
      System.find_or_create_message(
        "/users/:id/membership/new/ - buy new",
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

  def create(conn, %{"user_id" => user_id, "params" => params}) do
    user = Users.get_user!(user_id)

    # TODO
    # Make it look like when a product is added to the basket
    # but bounce direct to checkout

    IO.inspect product = Shop.get_product(params["product_id"])
    IO.inspect(params)
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