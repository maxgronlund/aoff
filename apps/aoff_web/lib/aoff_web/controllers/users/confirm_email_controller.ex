defmodule AOFFWeb.Users.ConfirmEmailController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(conn, %{"user_id" => user_id}) do
    prefix = conn.assigns.prefix

    if user = Users.get_user_by_reset_password_token(prefix, user_id) do
      Users.confirm_user(user)

      {:ok, message} =
        System.find_or_create_message(
          prefix,
          "Email confirmed",
          "Email confirmed",
          Gettext.get_locale(),
          conn.assigns.prefix
        )

      render(conn, "index.html", user: user, message: message)
    else
      conn
      |> put_status(404)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"404")
      |> halt()
    end
  end

  def show(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix

    if user = Users.get_user(prefix, id) do
      {:ok, message} =
        System.find_or_create_message(
          prefix,
          "Confirmation missing",
          "Confirmation missing",
          Gettext.get_locale()
        )

      render(conn, "confirmation_missing.html", user: user, message: message)
    else
      conn
      |> put_status(404)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"404")
      |> halt()
    end
  end
end
