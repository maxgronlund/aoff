defmodule AOFFWeb.Admin.AssociationController do
  use AOFFWeb, :controller

  alias AOFF.Admin
  alias AOFF.Admin.Association
  alias AOFF.Users

  def index(conn, _params) do
    _aoff = Admin.find_or_create_association("AOFF")
    associations = Admin.list_associations()

    render(
      conn,
      "index.html",
      associations: associations
    )
  end

  def new(conn, _params) do
    changeset = Admin.change_association(%Association{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      users: list_volunteers(conn.assigns.prefix)
    )
  end

  def create(conn, %{"association" => association_params}) do
    case Admin.create_association(association_params) do
      {:ok, association} ->
        prefix = AOFF.Admin.prefix(association.name)

        conn
        |> put_flash(:info, "IMPORTANT! run $ mix ecto.migrate --prefix \"#{prefix}\"")
        |> redirect(to: Routes.admin_association_path(conn, :show, association))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          users: list_volunteers(conn.assigns.prefix)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    association = Admin.get_association!(id)
    render(conn, "show.html", association: association)
  end

  def edit(conn, %{"id" => id}) do
    association = Admin.get_association!(id)
    changeset = Admin.change_association(association)

    render(
      conn,
      "edit.html",
      association: association,
      changeset: changeset,
      users: list_volunteers(conn.assigns.prefix)
    )
  end

  def update(conn, %{"id" => id, "association" => association_params}) do
    association = Admin.get_association!(id)

    case Admin.update_association(association, association_params) do
      {:ok, association} ->
        conn
        |> put_flash(:info, "Association updated successfully.")
        |> redirect(to: Routes.admin_association_path(conn, :show, association))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          association: association,
          changeset: changeset,
          users: list_volunteers(conn.assigns.prefix)
        )

      {:error, :rollback} ->
        render(
          conn,
          "edit.html",
          association: association,
          changeset: Admin.change_association(association),
          users: list_volunteers(conn.assigns.prefix)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    association = Admin.get_association!(id)
    {:ok, _association} = Admin.delete_association(association)

    conn
    |> put_flash(:info, "Association deleted successfully.")
    |> redirect(to: Routes.admin_association_path(conn, :index))
  end

  defp list_volunteers(prefix) do
    Enum.map(Users.list_volunteers(prefix), fn u -> {u.username, u.id} end)
  end
end
