defmodule AOFFWeb.Admin.UserController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Admin.Admins

  # plug BasicAuth, use_config: {:aoff_web, :basic_auth}

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

  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Admins.get_user!(id)
    changeset = Admins.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, email: user.email)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Admins.get_user!(id)

    case Admins.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.admin_user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, email: user.email)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Admins.get_user!(id)
    {:ok, _user} = Admins.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.admin_user_path(conn, :index))
  end
end
