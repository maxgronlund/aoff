defmodule AOFFWeb.EmailController do
  use Bamboo.Phoenix, view: AOFFWeb.EmailView
  alias AOFF.System
  alias AOFF.Users
  # alias AOFF.Volunteers
  import AOFFWeb.Gettext

  @email_from Application.get_env(:aoff_web, AOFFWeb.Mailer)[:email_from]

  def reset_password_email(prefix, username_and_email, reset_password_url) do
    # TODO: move out and remove prefix as param
    {:ok, message} =
      System.find_or_create_message(
        prefix,
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

  def invoice_email(prefix, order, cardno, paymenttype) do
    user = Users.get_user!(prefix, order.user_id)
    username_and_email = {user.username, user.email}

    new_email()
    |> to(username_and_email)
    |> from(@email_from)
    |> subject(gettext("Invoice"))
    |> put_header("Reply-To", @email_from)
    |> put_layout({AOFFWeb.EmailView, :invoice})
    |> render(:invoice, order: order, cardno: cardno, paymenttype: paymenttype)
  end

  def confirm_email_email(prefix, username_and_email, confirm_email_url) do
    # TODO: move out and remove prefix as param
    {:ok, message} =
      System.find_or_create_message(
        prefix,
        "Confirm email email",
        "Confirm email email",
        Gettext.get_locale()
      )

    new_email()
    |> to(username_and_email)
    |> from(@email_from)
    |> subject(gettext("Confirm email"))
    |> put_header("Reply-To", @email_from)
    |> put_layout({AOFFWeb.EmailView, :confirm_email})
    |> render(:confirm_email, confirm_email_url: confirm_email_url, message: message)
  end

  def send_newsletter(
        %AOFF.Volunteer.Newsletter{} = newsletter,
        username_and_email,
        unsubscribe_to_news_url
      ) do
    new_email()
    |> to(username_and_email)
    |> from(@email_from)
    |> subject(gettext("AOFF Newsletter"))
    |> put_header("Reply-To", @email_from)
    |> put_layout({AOFFWeb.EmailView, :newsletter})
    |> render(
      :newsletter,
      newsletter: newsletter,
      unsubscribe_to_news_url: unsubscribe_to_news_url
    )
  end

  def message_notification(username_and_email, message_url) do
    new_email()
    |> to(username_and_email)
    |> from(@email_from)
    |> subject(gettext("Message from AOFF"))
    |> put_header("Reply-To", @email_from)
    |> put_layout({AOFFWeb.EmailView, :message_notification})
    |> render(
      :message_notification,
      message_url: message_url
    )
  end
end
