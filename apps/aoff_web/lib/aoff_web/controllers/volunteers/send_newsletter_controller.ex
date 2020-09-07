defmodule AOFFWeb.Volunteer.SendNewsletterController do
  use AOFFWeb, :controller

  alias AOFF.Volunteers



  def update(conn, %{"id" => id}) do
    newsletter = Volunteers.get_newsletter!(id)

    for user <- AOFF.Users.list_users(:newsletter) do
      username_and_email = {user.username, user.email}
      AOFFWeb.EmailController.send_newsletter(newsletter, username_and_email)
    end

    Volunteers.newsletter_send(newsletter)

    conn
    |> redirect(to: Routes.volunteer_newsletter_path(conn, :show, newsletter))
  end
end
