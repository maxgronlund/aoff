# some/path/within/your/app/email.ex
defmodule AOFF.System.Email do
  import Bamboo.Email

  def welcome_email do
    new_email(
      to: "max@synthmax.dk",
      from: "max@synthmax.dk",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end