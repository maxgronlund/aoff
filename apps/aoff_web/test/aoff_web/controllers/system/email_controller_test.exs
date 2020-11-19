defmodule AOFFWeb.EmailControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture
  import AOFF.Users.OrderFixture
  import AOFF.Volunteer.NewsletterFixture

  alias AOFFWeb.EmailController
  alias AOFF.System
  alias AOFF.Users

  @email_from Application.get_env(:aoff_web, AOFFWeb.Mailer)[:email_from]

  test "reset_password_email/2 render a reset password email" do
    {:ok, message} =
      System.find_or_create_message(
        "/reset_password/:id/create",
        "Reset password",
        Gettext.get_locale(),
        "public"
      )

    user = user_fixture()
    username_and_email = {user.username, user.email}

    response = EmailController.reset_password_email(username_and_email, "https://example.com")
    assert %Bamboo.Email{from: @email_from, html_body: body} = response
    assert body =~ message.text
  end

  test "invoice_email/3 render an invoice email" do
    user = user_fixture()
    %AOFF.Users.Order{token: token} = order_fixture(user.id, %{})
    cardno = "0000 0000 0000 0000"

    order = Users.get_order_by_token!(token)

    response = EmailController.invoice_email(order, cardno, "Visa")
    assert %Bamboo.Email{from: @email_from, html_body: body} = response
    assert body =~ cardno
  end

  test "confirm_email/2 render an email confirmation email" do
    {:ok, message} =
      System.find_or_create_message(
        "Confirm email email",
        "Confirm email email",
        Gettext.get_locale(),
        "public"
      )

    user = user_fixture()
    username_and_email = {user.username, user.email}

    response = EmailController.confirm_email_email(username_and_email, "https://example.com")
    assert %Bamboo.Email{from: @email_from, html_body: body} = response
    assert body =~ message.text
  end

  test "send_neswletter/1 render a newsletter" do
    newsletter = newsletter_fixture()
    user = user_fixture(%{"subscribe_to_news" => true})
    username_and_email = {user.username, user.email}

    response =
      EmailController.send_newsletter(
        newsletter,
        username_and_email,
        "http://example.com/unsubscribe"
      )

    assert %Bamboo.Email{} = response
  end
end
