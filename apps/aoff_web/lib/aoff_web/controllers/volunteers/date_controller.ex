defmodule AOFFWeb.Volunteer.DateController do
  use AOFFWeb, :controller

  alias AOFF.Shop
  alias AOFF.Users

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :edit, :new, :update, :create, :delete]


  def index(conn, params) do

    Shop.secure_dates()

    page = params["page"] || "0"

    dates = Shop.list_dates(Date.utc_today(), String.to_integer(page), 12)

    render(
      conn,
      "index.html",
      dates: dates,
      pages: Shop.date_pages(),
      page: String.to_integer(page)
    )
  end

  def new(conn, _params) do
    changeset = Shop.change_date(%AOFF.Shop.Date{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      users: shop_assistans(),
      date: false
    )
  end

  def create(conn, %{"date" => date_params}) do
    case Shop.create_date(date_params) do
      {:ok, date} ->
        conn
        |> put_flash(:info, gettext("Please add an image"))
        |> redirect(to: Routes.volunteer_date_path(conn, :edit, date))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          users: shop_assistans(),
          date: false
        )
    end
  end

  def show(conn, %{"id" => id}) do
    date = Shop.get_date!(id)

    render(
      conn,
      "show.html",
      date: date
    )
  end

  def edit(conn, %{"id" => id}) do
    date = Shop.get_date!(id)

    changeset = Shop.change_date(date)
    render(conn, "edit.html", date: date, changeset: changeset, users: shop_assistans())
  end

  def update(conn, %{"id" => id, "date" => date_params}) do
    date = Shop.get_date!(id)

    case Shop.update_date(date, date_params) do
      {:ok, _date} ->
        conn
        |> put_flash(:info, "Date updated successfully.")
        |> redirect(to: Routes.volunteer_date_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", date: date, changeset: changeset, users: shop_assistans())
    end
  end

  def delete(conn, %{"id" => id}) do
    date = Shop.get_date!(id)
    {:ok, _date} = Shop.delete_date(date)

    conn
    |> put_flash(:info, "Date deleted successfully.")
    |> redirect(to: Routes.volunteer_date_path(conn, :index))
  end

  defp shop_assistans() do
    Enum.map(Users.list_shop_assistans(), fn u -> {u.username, u.id} end)
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :page, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
