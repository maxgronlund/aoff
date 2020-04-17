defmodule AOFFWeb.SessionController do
  use AOFFWeb, :controller

  alias AOFF.Users

  def new(conn, _params) do
    conn = assign(conn, :page, :session)
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case AOFFWeb.Users.Auth.login_by_email_and_pass(conn, email, pass) do
      {:ok, conn} ->
        user = conn.assigns[:current_user]

        conn
        |> put_flash(
          :info,
          gettext("Welcome back! %{username}", username: user.username)
        )
        |> redirect(to: Routes.user_path(conn, :show, user.id))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, gettext("Invalid email/password combination"))
        |> render("new.html")
    end
  end

  def show(conn, params) do
    conn
    |> AOFFWeb.Users.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    IO.inspect("delete")

    conn
    |> AOFFWeb.Users.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
