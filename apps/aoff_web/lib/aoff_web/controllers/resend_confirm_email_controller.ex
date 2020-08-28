defmodule AOFFWeb.ResendConfirmEmailController do
  use AOFFWeb, :controller
  alias AOFF.System
  alias AOFF.Users.User
  alias AOFF.Users

  def new(conn, params) do
    {:ok, message} =
      System.find_or_create_message(
        "Resend confirmation email",
        "Resend confirmation email",
        Gettext.get_locale()
      )

    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset, message: message)
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Users.get_user_by_email(email) do
      resend_confirm_email(conn, user)
    end

    redirect(conn, to: Routes.resend_confirm_email_path(conn, :index))
  end

  def index(conn, params) do
    {:ok, message} =
      System.find_or_create_message(
        "Confirmation email was resend",
        "Confirmation email was resend",
        Gettext.get_locale()
      )

    render(conn, :index, message: message)
  end

  defp resend_confirm_email(conn, user) do
    username_and_email = {user.username, user.email}

    confirm_email_url =
      AOFFWeb.Router.Helpers.url(conn) <>
        "/users/" <>
        user.password_reset_token <>
        "/confirm_email"

    # Create your email
    AOFFWeb.Email.confirm_email_email(username_and_email, confirm_email_url)
    |> AOFFWeb.Mailer.deliver_now()
  end
end
