defmodule AOFFWeb.UserController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.User
  alias AOFFWeb.Users.Auth
  alias AOFF.System
  plug Auth
  plug :authenticate when action in [:index, :show, :edit, :update, :delete]
  plug :navbar when action in [:new, :show, :edit]

  def index(conn, _params) do
    authorize(conn, conn.assigns.current_user)
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    last_member_nr = Users.last_member_nr() || 0

    changeset =
      Users.change_user(%User{
        expiration_date: ~D[2021-03-31],
        member_nr: last_member_nr + 1
      })

    {:ok, message} =
      System.find_or_create_message(
        "/users/new",
        "Create account",
        Gettext.get_locale()
      )

    render(conn, "new.html", changeset: changeset, email: "", message: message, user: false)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        Auth.login(conn, user)
        |> put_flash(
          :info,
          gettext("Welcome %{username}, your account is created", username: user.username)
        )
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, message} =
          System.find_or_create_message(
            "/users/new",
            "Create account",
            Gettext.get_locale()
          )

        render(
          conn,
          "new.html",
          changeset: changeset,
          email: user_params["email_confirmation"],
          message: message,
          user: false
        )
    end
  end

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :user)
    user = get_user!(conn, id)
    host_dates = Users.host_dates(Date.utc_today(), user.id)

    {:ok, message} =
      System.find_or_create_message(
        "Pay for membership",
        "Pay for membership",
        Gettext.get_locale()
      )

    render(conn, "show.html", user: user, message: message, host_dates: host_dates)
  end

  def edit(conn, %{"id" => id}) do
    {:ok, avatar_format} =
      System.find_or_create_message(
        "/user/:id/edit",
        "Avatar format",
        Gettext.get_locale()
      )

    user = get_user!(conn, id)
    changeset = Users.change_user(user)

    render(
      conn,
      "edit.html",
      user: user,
      changeset: changeset,
      email: user.email,
      avatar_format: avatar_format
    )
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = get_user!(conn, id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, email: user.email)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.page_path(conn, :index))
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
         current_user.volunteer ||
         current_user.id == user.id do
      user
    else
      conn
      |> put_status(403)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"403")
      |> halt()
    end
  end

  defp navbar(conn, _opts) do
    assign(conn, :page, :user)
  end
end
