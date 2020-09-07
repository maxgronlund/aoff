defmodule AOFFWeb.Volunteer.SendNewsletterController do
  use AOFFWeb, :controller

  alias AOFF.Volunteers

  def update(conn, %{"id" => id}) do
    newsletter = Volunteers.get_newsletter!(id)

    for user <- AOFF.Users.list_users(:newsletter) do
      newsletter
      |> AOFFWeb.EmailController.send_newsletter({user.username, user.email})
      |> AOFFWeb.Mailer.deliver_now()
    end

    Volunteers.newsletter_send(newsletter)

    conn
    |> put_flash(:info, gettext("Newsletter send successfully."))
    |> redirect(to: Routes.volunteer_newsletter_path(conn, :show, newsletter))
  end
end
