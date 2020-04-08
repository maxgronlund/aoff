defmodule AOFFWeb.Volunteer.UserController do
  use AOFFWeb, :controller

  alias AOFF.Volunteers
  alias AOFF.Users

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :edit, :update, :delete]

  def index(conn, params) do
    users =
      if query = params["query"] do
        Users.search_users(query)
      else
        page = params["page"] || "0"
        Users.list_users(String.to_integer(page))
      end

    render(conn, "index.html", users: users, pages: Users.user_pages())
  end

  def edit(conn, %{"id" => id}) do
    user = Volunteers.get_user!(id)
    changeset = Volunteers.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, email: user.email)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = get_user!(conn, id)

    case Volunteers.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.volunteer_user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, email: user.email)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = get_user!(conn, id)
    {:ok, _user} = Volunteers.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.volunteer_user_path(conn, :index))
  end

  defp get_user!(conn, id) do
    user = Users.get_user!(id)

    if user do
      authorize(conn, user)
    else
      conn
      |> put_status(404)
      |> put_view(BEWeb.ErrorView)
      |> render(:"404")
      |> halt()
    end
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

  defp authorize(conn, user) do
    current_user = conn.assigns.current_user

    if current_user.admin ||
         current_user.volunteer do
      user
    else
      conn
      |> put_status(403)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"403")
      |> halt()
    end
  end
end
