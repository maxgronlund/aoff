defmodule AOFFWeb.Admin.UserController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Admin.Admins

  # plug BasicAuth, use_config: {:aoff_web, :basic_auth}

  def index(conn, params) do
    prefix = conn.assigns.prefix
    users =
      if query = params["query"] do
        Users.search_users(query, prefix)
      else
        page = params["page"] || "0"
        Users.list_users(prefix, String.to_integer(page))
      end

    render(conn, "index.html", users: users, pages: Users.user_pages(prefix))
  end

  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    user = Admins.get_user!(id, prefix)
    changeset = Admins.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, email: user.email)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    prefix = conn.assigns.prefix
    user = Admins.get_user!(id, prefix)

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
    prefix = conn.assigns.prefix
    user = Admins.get_user!(id, prefix)
    {:ok, _user} = Admins.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.admin_user_path(conn, :index))
  end
end
