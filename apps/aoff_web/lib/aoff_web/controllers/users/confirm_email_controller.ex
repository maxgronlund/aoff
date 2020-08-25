defmodule AOFFWeb.Users.ConfirmEmailController do
  use AOFFWeb, :controller

  alias AOFF.Users
  alias AOFF.System

  def index(conn, %{"user_id" => user_id}) do
    if user = Users.get_user_by_reset_password_token(user_id) do
      Users.confirm_user(user)

      {:ok, message} =
        System.find_or_create_message(
          "Email confirmed",
          "Email confirmed",
          Gettext.get_locale()
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
    if user = Users.get_user(id) do
      {:ok, message} =
        System.find_or_create_message(
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
