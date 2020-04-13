defmodule AOFFWeb.ResetPasswordController do
  use AOFFWeb, :controller

  alias AOFF.Users.User
  alias AOFF.Users
  alias AOFF.System

  def index(conn, _params) do
    {:ok, message } = System.find_or_create_message("/reset_password/index", Gettext.get_locale())
    render(conn, "index.html", message: message)
  end

  def new(conn, _params) do
    {:ok, message } = System.find_or_create_message("/reset_password/new", Gettext.get_locale())
    changeset =
      Users.change_user(%User{})

    render(conn, "new.html", changeset: changeset, message: message)
  end

  def create(conn, params) do
    email = params["user"]["email"]
    case Users.get_user_by_email(email) do
      %User{} = user ->
        token = Ecto.UUID.generate()
        Users.set_password_reset_token(
          user,
          %{
            "password_reset_token" => token,
            "password_reset_expires" => NaiveDateTime.utc_now()
          }
        )
        reset_password_url =
          AOFFWeb.Router.Helpers.url(conn) <>
          conn.request_path <>
          "/" <> token <> "/edit"
        username_and_email =
          {user.username, user.email}

        AOFFWeb.Email.reset_password_email(username_and_email, reset_password_url)   # Create your email
        |> AOFFWeb.Mailer.deliver_now()
    end

    redirect(conn, to: Routes.reset_password_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    case Users.get_user_by_reset_password_token(id) do
      %User{} = user ->
        changeset = Users.change_user(user)
        render(conn, "edit.html", user: user, changeset: changeset)
      _ ->
        render(conn, "not_found.html")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case NaiveDateTime.compare(
              NaiveDateTime.utc_now(),
              NaiveDateTime.add(user.password_reset_expires, 900, :second)
            ) do
    :gt -> render(conn, "expired.html")
    :lt -> update(conn, user, user_params)
    end
  end

  def update(conn, user, user_params) do
     case Users.update_password!(user, user_params) do
      {:ok, user} ->
        redirect(conn, to: Routes.session_path(conn, :new))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

end