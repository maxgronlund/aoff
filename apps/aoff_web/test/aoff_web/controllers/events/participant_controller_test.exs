defmodule AOFFWeb.Events.ParticipantControllerTest do
  use AOFFWeb.ConnCase

  import AOFF.Content.CategoryFixture
  import AOFF.Content.PageFixture
  import AOFF.Users.UserFixture
  import AOFF.Events.ParticipantFixture
  import AOFFWeb.Gettext
  alias Plug.Conn

  describe "events as a member" do
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

    test "new/1 renders new participant form", %{conn: conn, user: user, page: page} do
      conn =
        get(
          conn,
          Routes.events_calendar_participant_path(conn, :new, page.id)
        )
      assert html_response(conn, 200) =~ gettext("Sign me up to %{title}", title: page.title)
    end

    test "create/1 adds a participant to an event", %{conn: conn, user: user, page: page} do
      conn =
        post(
          conn,
          Routes.events_calendar_participant_path(conn, :create, page.id),
          participant: %{"user_id" => user.id, "page_id" => page.id}
        )

      assert redirected_to(conn) == Routes.calendar_path(conn, :show, page.title)
    end

    # test "delete/1 deletes participation", %{
    #   conn: conn,
    #   user: user,
    #   page: page,
    #   category: category
    # } do
    #   {:ok, participant} = participant_fixture(%{"user_id" => user.id, "page_id" => page.id})

    #   conn =
    #     delete(
    #       conn,
    #       Routes.events_participant_path(conn, :delete, participant)
    #     )

    #   assert redirected_to(conn) == Routes.calendar_path(conn, :show, page.title)
    # end
  end
end
