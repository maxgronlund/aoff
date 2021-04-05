defmodule AOFF.Volunteer.SendNewsletterControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn

  import AOFF.Users.UserFixture
  import AOFF.Volunteer.NewsletterFixture
  import AOFF.Admin.AssociationFixture

  describe "as a volunteer" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      _association = association_fixture()

      user =
        user_fixture(%{
          "volunteer" => true,
          "text_editor" => true,
          "subscribe_to_news" => true
        })

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(:prefix, "public")

      {:ok, conn: conn, user: user}
    end

    test "update/2 sends the newsletter", %{conn: conn} do
      newsletter = newsletter_fixture()
      conn = put(conn, Routes.volunteer_send_newsletter_path(conn, :update, newsletter))
      assert redirected_to(conn) == Routes.volunteer_newsletter_path(conn, :show, newsletter)
    end
  end
end
