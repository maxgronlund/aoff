defmodule AOFFWeb.Volunteer.CommitteeController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Committees.Committee

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    committees = Committees.list_committees(conn.assigns.prefix)
    render(conn, "index.html", committees: committees)
  end

  def new(conn, _params) do
    changeset = Committees.change_committee(%Committee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"committee" => committee_params}) do
    case Committees.create_committee(committee_params, conn.assigns.prefix) do
      {:ok, committee} ->
        conn
        |> put_flash(:info, gettext("Committee created successfully."))
        |> redirect(to: Routes.committee_committee_path(conn, :show, committee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    committee = Committees.get_committee!(id, prefix)
    changeset = Committees.change_committee(committee)
    render(conn, "edit.html", committee: committee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "committee" => committee_params}) do
    prefix = conn.assigns.prefix
    committee = Committees.get_committee!(id, prefix)

    case Committees.update_committee(committee, committee_params) do
      {:ok, _committee} ->
        conn
        |> put_flash(:info, gettext("Committee updated successfully."))
        |> redirect(to: Routes.volunteer_committee_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", committee: committee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    committee = Committees.get_committee!(id, prefix)
    {:ok, _committee} = Committees.delete_committee(committee)

    conn
    |> put_flash(:info, gettext("Committee deleted successfully."))
    |> redirect(to: Routes.volunteer_committee_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.admin do
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
