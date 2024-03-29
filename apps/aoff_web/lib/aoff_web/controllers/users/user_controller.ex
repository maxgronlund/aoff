defmodule AOFFWeb.UserController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.Users.User
  alias AOFFWeb.Users.Auth
  alias AOFF.System
  alias AOFF.Shop
  plug Auth
  plug :authenticate when action in [:index, :show, :edit, :update, :delete]
  plug :navbar when action in [:new, :edit]

  def new(conn, _params) do
    prefix = conn.assigns.prefix
    last_member_nr = Users.last_member_nr(prefix) || 0

    changeset =
      Users.change_user(%User{
        expiration_date: AOFF.Time.today(),
        member_nr: last_member_nr + 1
      })

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "/users/new",
        "Create account",
        Gettext.get_locale()
      )

    render(
      conn,
      "new.html",
      changeset: changeset,
      email: "",
      message: message,
      user: false
    )
  end

  def create(conn, %{"user" => user_params}) do
    prefix = conn.assigns.prefix

    case Users.create_user(prefix, user_params) do
      {:ok, user} ->
        username_and_email = {user.username, user.email}
        host_url = AOFF.Admin.get_host_by_prefix(prefix)

        confirm_email_url =
          host_url <>
            "/users/" <>
            user.password_reset_token <>
            "/confirm_email"

        AOFFWeb.EmailController.confirm_email_email(
          conn.assigns.prefix,
          username_and_email,
          confirm_email_url
        )
        |> AOFFWeb.Mailer.deliver_now()

        redirect(conn, to: Routes.user_welcome_path(conn, :index, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, message} =
          System.find_or_create_message(
            prefix,
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
    prefix = conn.assigns.prefix
    today = AOFF.Time.today()
    user = get_user!(conn, id)
    upcomming_pick_ups = Shop.list_upcomming_pick_ups(prefix, user.id, today)
    upcomming_meetings = AOFF.Committees.list_user_meetings(prefix, user.id, today)

    conn =
      conn
      |> assign(:selected_menu_item, :user)
      |> assign(:title, user.username)

    host_dates = Users.host_dates(prefix, Date.utc_today(), user.id)

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "Pay for membership",
        "Pay for membership",
        Gettext.get_locale()
      )

    render(
      conn,
      "show.html",
      user: user,
      message: message,
      host_dates: host_dates,
      upcomming_pick_ups: upcomming_pick_ups,
      upcomming_meetings: upcomming_meetings
    )
  end

  def edit(conn, %{"id" => id}) do
    user = get_user!(conn, id)

    conn =
      conn
      |> assign(:selected_menu_item, :user)
      |> assign(:title, gettext("Edit account"))

    changeset = Users.change_user(user)

    render(
      conn,
      "edit.html",
      user: user,
      changeset: changeset,
      email: user.email,
      avatar_format: avatar_format(conn.assigns.prefix)
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
        render(
          conn,
          "edit.html",
          user: user,
          changeset: changeset,
          email: user.email,
          avatar_format: avatar_format(conn.assigns.prefix)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    user = Users.get_user!(prefix, id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp get_user!(conn, id) do
    prefix = conn.assigns.prefix

    if user = Users.get_user(prefix, id) do
      authorize(conn, user)
    else
      conn
      |> put_status(404)
      |> put_view(AOFFWeb.ErrorView)
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
    conn
    |> assign(:selected_menu_item, :user)
  end

  defp avatar_format(prefix) do
    {:ok, avatar_format} =
      System.find_or_create_message(
        prefix,
        "/user/:id/edit",
        "Avatar format",
        Gettext.get_locale()
      )

    avatar_format
  end
end
