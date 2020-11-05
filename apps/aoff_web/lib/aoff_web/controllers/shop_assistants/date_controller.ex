defmodule AOFFWeb.ShopAssistant.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFFWeb.Users.Auth
  alias AOFF.Users

  plug Auth
  plug :authenticate when action in [:index, :show, :edit, :update]
  plug :navbar when action in [:index]

  @dates_pr_page 12

  def index(conn, params) do
    prefix = conn.assigns.prefix
    page =
      case params["page"] do
        nil -> Shop.todays_page(@dates_pr_page)
        page -> String.to_integer(page)
      end

    dates = Shop.list_all_dates(AOFF.Time.today(), page, @dates_pr_page, prefix)
    date = Shop.get_next_date(AOFF.Time.today(), prefix)

    render(
      conn,
      "index.html",
      dates: dates,
      date: date,
      pages: Shop.date_pages(),
      page: page
    )
  end

  def show(conn, params) do
    prefix = conn.assigns.prefix
    date = Shop.get_date!(params["id"], prefix)
    query = params["query"]

    conn =
      conn
      |> put_session(:shop_assistant_date_id, date.id)
      |> assign(:title, gettext("Shop duty"))
      |> assign(:selected_menu_item, :shop)

    pick_ups =
      if query do
        Shop.search_pick_up(query, params["id"], prefix)
      else
        Shop.list_pick_ups(date.id, prefix)
      end

    render(
      conn,
      "show.html",
      date: date,
      pick_ups: pick_ups
    )
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    date = Shop.get_date!(id, prefix)

    changeset = Shop.change_date(date)
    render(conn, "edit.html", date: date, changeset: changeset, users: shop_assistans(prefix))
  end

  def update(conn, %{"id" => id, "date" => date_params}) do
    prefix = conn.assigns.prefix
    date = Shop.get_date!(id, prefix)

    case Shop.update_date(date, date_params) do
      {:ok, _date} ->
        conn
        |> put_flash(:info, gettext("Date updated successfully."))
        |> redirect(to: Routes.shop_assistant_date_path(conn, :show, date))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", date: date, changeset: changeset, users: shop_assistans(prefix))
    end
  end

  defp shop_assistans(prefix) do
    Enum.map(Users.list_shop_assistans(prefix), fn u -> {u.username, u.id} end)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.shop_assistant do
      assign(conn, :selected_menu_item, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  defp navbar(conn, _opts) do
    conn
    |> assign(:selected_menu_item, :volunteer)
    |> assign(:title, gettext("Shop duties"))
  end
end
