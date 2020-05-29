defmodule AOFFWeb.Volunteer.OrderController do
  use AOFFWeb, :controller


  alias AOFF.Users
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index]

  @orders_pr_page 8

  def index(conn, params) do
    page = page(params)
    pages = pages(params)
    orders =
      if query = params["query"] do
        Users.search_orders(query)
      else
        Users.orders_page(page, @orders_pr_page)
      end
    conn
    |> put_session(:shop_assistant_date_id, nil)
    |> render("index.html",
      orders: orders,
      page: page,
      pages: pages
    )
  end

  defp page(params) do
    cond do
      params["query"] -> false
      true -> String.to_integer(params["page"] || "0")
    end
  end

  defp pages(params) do
    cond do
      params["query"] -> false
      true -> Users.order_pages(@orders_pr_page)
    end
  end

  # def new(conn, %{"committee_id" => committee_id}) do
  #   committee = Committees.get_committee!(committee_id)
  #   changeset = Committees.change_member(%Member{})

  #   render(conn, "new.html",
  #     changeset: changeset,
  #     committee: committee,
  #     users: list_volunteers()
  #   )
  # end

  # def create(conn, %{"member" => member_params}) do
  #   case Committees.create_member(member_params) do
  #     {:ok, member} ->
  #       conn
  #       |> put_flash(:info, gettext("Member created successfully."))
  #       |> redirect(to: Routes.committee_committee_path(conn, :show, member.committee_id))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       committee = Committees.get_committee!(member_params["committee_id"])

  #       render(conn, "new.html",
  #         changeset: changeset,
  #         committee: committee,
  #         users: list_volunteers()
  #       )
  #   end
  # end

  def show(conn, %{"id" => id}) do
    order = Users.get_order!(id)
    render(conn, "show.html", order: order)
  end

  # def edit(conn, %{"id" => id}) do
  #   member = Committees.get_member!(id)
  #   changeset = Committees.change_member(member)

  #   render(conn, "edit.html",
  #     committee: member.committee,
  #     member: member,
  #     changeset: changeset,
  #     users: list_volunteers()
  #   )
  # end

  # def update(conn, %{"id" => id, "member" => member_params}) do
  #   member = Committees.get_member!(id)

  #   case Committees.update_member(member, member_params) do
  #     {:ok, member} ->
  #       conn
  #       |> put_flash(:info, gettext("Member updated successfully."))
  #       |> redirect(to: Routes.committee_committee_path(conn, :show, member.committee_id))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html",
  #         member: member,
  #         committee: member.committee,
  #         users: list_volunteers(),
  #         changeset: changeset
  #       )
  #   end
  # end

  def delete(conn, %{"id" => id}) do

    order = Users.get_order(id)
    {:ok, _order} = Users.delete_order(order)


    conn
    |> put_flash(:info, gettext("Order deleted successfully."))
    |> redirect(to: Routes.volunteer_order_path(conn, :index))
  end

  # defp list_volunteers() do
  #   Enum.map(Users.list_volunteers(), fn u -> {u.username, u.id} end)
  # end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :selected_menu_item, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
