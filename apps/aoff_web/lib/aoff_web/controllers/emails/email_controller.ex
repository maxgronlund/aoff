# some/path/within/your/app/email.ex
defmodule AOFFWeb.Email do
  use Bamboo.Phoenix, view: AOFFWeb.EmailView
  alias AOFF.System
  alias AOFF.Users
  import AOFFWeb.Gettext

  @email_from Application.get_env(:aoff_web, AOFFWeb.Mailer)[:email_from]

  def reset_password_email(username_and_email, reset_password_url) do
    {:ok, message} =
      System.find_or_create_message(
        "/reset_password/:id/create",
        "Reset password",
        Gettext.get_locale()
      )

    new_email()
    |> to(username_and_email)
    |> from(@email_from)
    |> subject(gettext("Reset password"))
    |> put_header("Reply-To", @email_from)
    |> put_layout({AOFFWeb.EmailView, :reset_password})
    |> render(:reset_password, reset_password_url: reset_password_url, message: message)
  end

  def invoice_email(order, cardno, paymenttype) do

    user = Users.get_user!(order.user_id)
    username_and_email = {user.username, user.email}

    new_email()
    |> to(username_and_email)
    |> from(@email_from)
    |> subject(gettext("Invoice"))
    |> put_header("Reply-To", @email_from)
    |> put_layout({AOFFWeb.EmailView, :invoice})
    |> render(:invoice, order: order, cardno: cardno, paymenttype: paymenttype)
  end
end
