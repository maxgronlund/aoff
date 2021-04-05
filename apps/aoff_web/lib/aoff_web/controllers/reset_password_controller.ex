defmodule AOFFWeb.ResetPasswordController do
  use AOFFWeb, :controller

  alias AOFF.Users.User
  alias AOFF.Users
  alias AOFF.System

  def index(conn, _params) do
    {:ok, message} =
      System.find_or_create_message(
        conn.assigns.prefix,
        "/reset_password/index",
        "Reset password",
        Gettext.get_locale()
      )

    render(conn, "index.html", message: message)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      message: new_message(conn.assigns.prefix)
    )
  end

  defp new_message(prefix) do
    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "/reset_password/new",
        "Send reset pasword email",
        Gettext.get_locale()
      )

    message
  end

  def create(conn, params) do
    email = params["user"]["email"]
    prefix = conn.assigns.prefix

    case Users.get_user_by_email(prefix, email) do
      %User{} = user ->
        token = Ecto.UUID.generate()

        Users.set_password_reset_token(
          user,
          %{
            "password_reset_token" => token,
            "password_reset_expires" => AOFF.Time.now()
          }
        )

        host_url = AOFF.Admin.get_host_by_prefix(prefix)
        reset_password_url = host_url <> "/reset_password/" <> token <> "/edit"

        username_and_email = {user.username, user.email}

        # Create your email
        AOFFWeb.EmailController.reset_password_email(
          prefix,
          username_and_email,
          reset_password_url
        )
        |> AOFFWeb.Mailer.deliver_now()

      _ ->
        changeset = Users.change_user(%User{})

        conn
        |> put_flash(:error, gettext("Please check the email"))
        |> render("new.html", changeset: changeset, message: new_message(prefix))
    end

    redirect(conn, to: Routes.reset_password_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    case Users.get_user_by_reset_password_token(prefix, id) do
      %User{} = user ->
        changeset = Users.change_user(user)
        render(conn, "edit.html", user: user, changeset: changeset)

      _ ->
        render(conn, "not_found.html")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    prefix = conn.assigns.prefix
    user = Users.get_user!(prefix, id)

    case DateTime.compare(
           AOFF.Time.now(),
           DateTime.add(user.password_reset_expires, 900, :second)
         ) do
      :gt -> render(conn, "expired.html")
      :lt -> update(conn, user, user_params)
    end
  end

  def update(conn, user, user_params) do
    case Users.update_password!(user, user_params) do
      {:ok, _user} ->
        redirect(conn, to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
