defmodule AOFFWeb.Volunteer.SendNewsletterController do
  use AOFFWeb, :controller

  alias AOFF.Volunteers

  def update(conn, %{"id" => id}) do
    prefix = conn.assigns.prefix
    newsletter = Volunteers.get_newsletter!(prefix, id)

    for user <- AOFF.Users.list_users(prefix, :newsletter) do
      unsubscribe_to_news_url =
        Routes.unsubscribe_to_news_url(conn, :show, user.unsubscribe_to_news_token)

      newsletter
      |> AOFFWeb.EmailController.send_newsletter(
        {user.username, user.email},
        unsubscribe_to_news_url
      )
      |> AOFFWeb.Mailer.deliver_now()
    end

    Volunteers.newsletter_send(newsletter)

    conn
    |> put_flash(:info, gettext("Newsletter send successfully."))
    |> redirect(to: Routes.volunteer_newsletter_path(conn, :show, newsletter))
  end
end
