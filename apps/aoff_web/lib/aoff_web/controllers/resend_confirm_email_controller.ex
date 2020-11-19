defmodule AOFFWeb.ResendConfirmEmailController do
  use AOFFWeb, :controller
  alias AOFF.System
  alias AOFF.Users.User
  alias AOFF.Users

  def new(conn, _params) do
    prefix = conn.assigns.prefix

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "Resend confirmation email",
        "Resend confirmation email",
        Gettext.get_locale()
      )

    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset, message: message)
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    prefix = conn.assigns.prefix

    if user = Users.get_user_by_email(prefix, email) do
      resend_confirm_email(conn, user)
    end

    redirect(conn, to: Routes.resend_confirm_email_path(conn, :index))
  end

  def index(conn, _params) do
    prefix = conn.assigns.prefix

    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "Confirmation email was resend",
        "Confirmation email was resend",
        Gettext.get_locale()
      )

    render(conn, :index, message: message)
  end

  defp resend_confirm_email(conn, user) do
    username_and_email = {user.username, user.email}

    token = Ecto.UUID.generate()

    Users.set_password_reset_token(
      user,
      %{"password_reset_token" => token}
    )

    confirm_email_url =
      AOFFWeb.Router.Helpers.url(conn) <>
        conn.request_path <>
        "/" <>
        token <>
        "/confirm_email"

    AOFFWeb.EmailController.confirm_email_email(
      conn.assigns.prefix,
      username_and_email,
      confirm_email_url
    )
    |> AOFFWeb.Mailer.deliver_now()
  end
end
