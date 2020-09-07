defmodule AOFFWeb.Events.ParticipantControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.Content.CategoryFixture
  import AOFF.Content.PageFixture
  import AOFF.Users.UserFixture
  import AOFF.Events.ParticipantFixture
  alias Plug.Conn

  describe "events" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture()
      category = category_fixture()
      page = page_fixture(category.id)

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, page: page, category: category}
    end

    test "create/1 adds a participant to a page", %{conn: conn, user: user, page: page} do
      conn =
        post(
          conn,
          Routes.events_participant_path(conn, :create),
          participant: %{"user_id" => user.id, "page_id" => page.id}
        )

      assert redirected_to(conn) == Routes.calendar_path(conn, :show, page.title)
    end

    test "delete/1 deletes participation", %{
      conn: conn,
      user: user,
      page: page,
      category: category
    } do
      {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})

      conn =
        delete(
          conn,
          Routes.events_participant_path(conn, :delete, participant)
        )

      assert redirected_to(conn) == Routes.calendar_path(conn, :show, page.title)
    end
  end
end
