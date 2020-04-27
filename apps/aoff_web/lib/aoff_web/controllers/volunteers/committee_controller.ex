defmodule AOFFWeb.Volunteer.CommitteeController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Committees.Committee

  # alias AOFFWeb.Users.Auth
  # plug Auth
  # plug :authenticate when action in [:show]

  def index(conn, _params) do
    committees = Committees.list_committees()
    render(conn, "index.html", committees: committees)
  end

  def new(conn, _params) do
    changeset = Committees.change_committee(%Committee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"committee" => committee_params}) do
    case Committees.create_committee(committee_params) do
      {:ok, committee} ->
        conn
        |> put_flash(:info, gettext("Committee created successfully."))
        |> redirect(to: Routes.volunteer_committee_path(conn, :show, committee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    committee = Committees.get_committee!(id)
    render(conn, "show.html", committee: committee)
  end

  def edit(conn, %{"id" => id}) do
    committee = Committees.get_committee!(id)
    changeset = Committees.change_committee(committee)
    render(conn, "edit.html", committee: committee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "committee" => committee_params}) do
    committee = Committees.get_committee!(id)

    case Committees.update_committee(committee, committee_params) do
      {:ok, committee} ->
        conn
        |> put_flash(:info, gettext("Committee updated successfully."))
        |> redirect(to: Routes.volunteer_committee_path(conn, :show, committee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", committee: committee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    committee = Committees.get_committee!(id)
    {:ok, _committee} = Committees.delete_committee(committee)

    conn
    |> put_flash(:info, gettext("Committee deleted successfully."))
    |> redirect(to: Routes.volunteer_committee_path(conn, :index))
  end

  # defp authenticate(conn, _opts) do
  #   if conn.assigns.shop_assistant do
  #     assign(conn, :page, :shop_assistant)
  #   else
  #     conn
  #     |> put_status(401)
  #     |> put_view(AOFFWeb.ErrorView)
  #     |> render(:"401")
  #     |> halt()
  #   end
  # end
end
