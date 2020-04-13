# some/path/within/your/app/email.ex
defmodule AOFFWeb.Email do
  use Bamboo.Phoenix, view: AOFFWeb.EmailView
  alias AOFF.System

  def reset_password_email(username_and_email, reset_password_url) do
    {:ok, message } =
      System.find_or_create_message(
        "/reset_password/:id/create",
        Gettext.get_locale()
      )
    new_email()
    |> to(username_and_email)
    |> from("max@synthmax.dk")
    |> subject("Reset password")
    |> put_header("Reply-To", "max@synthmax.dk")
    |> put_layout({AOFFWeb.EmailView, :reset_password})
    |> render(:reset_password, reset_password_url: reset_password_url, message: message)
  end
end