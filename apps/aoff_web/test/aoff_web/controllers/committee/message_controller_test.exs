defmodule AOFFWeb.Committees.MessageControllerTest do
  use AOFFWeb.ConnCase

  alias AOFF.Committees

  import AOFF.Committees.MessageFixture
  import AOFF.Committees.CommitteeFixture
  import AOFF.Committees.MemberFixture
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  alias Plug.Conn

  # @create_attrs %{body: "some body", from: "some from", posted_at: "2010-04-17T14:00:00.000000Z", title: "some title"}
  # @update_attrs %{body: "some updated body", from: "some updated from", posted_at: "2011-05-18T15:01:01.000000Z", title: "some updated title"}
  # @invalid_attrs %{body: nil, from: nil, posted_at: nil, title: nil}

  # def fixture(:message) do
  #   {:ok, message} = Committees.create_message(@create_attrs)
  #   message
  # end

  describe "as a committee member" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => true})

      committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(:prefix, "public")


      {:ok, conn: conn, user: user, committee: committee}
    end

    test "index lists all messages", %{conn: conn, committee: committee} do
      _message = message_fixture(%{"committee_id" => committee.id})
      conn = get(conn, Routes.committee_committee_message_path(conn, :index, committee))
      assert html_response(conn, 200) =~ gettext("Messages")
    end

    test "new message renders form", %{conn: conn, committee: committee} do
      conn = get(conn, Routes.committee_committee_message_path(conn, :new, committee))
      assert html_response(conn, 200) =~ gettext("New Message")
    end

    test "create message redirects to show when data is valid", %{
      conn: conn,
      committee: committee
    } do
      attrs = valid_message_attrs(%{"committee_id" => committee.id})

      conn =
        post(conn, Routes.committee_committee_message_path(conn, :create, committee),
          message: attrs
        )

      assert %{committee_id: committee_id} = redirected_params(conn)

      assert redirected_to(conn) ==
               Routes.committee_committee_message_path(conn, :index, committee)

      messages = Committees.list_messages("public", committee_id)
      message = List.first(messages)

      conn = get(conn, Routes.committee_committee_message_path(conn, :show, committee, message))
      assert html_response(conn, 200) =~ message.title
    end

    test "show message renders show", %{conn: conn, committee: committee} do
      message = message_fixture(%{"committee_id" => committee.id})
      conn = get(conn, Routes.committee_committee_message_path(conn, :show, committee, message))
      assert html_response(conn, 200) =~ message.body
    end
  end

  describe "as a volunteer" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => true})

      committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user, committee: committee}
    end

    test "index lists all messages returns 401", %{conn: conn, committee: committee} do
      _message = message_fixture(%{"committee_id" => committee.id})
      conn = get(conn, Routes.committee_committee_message_path(conn, :index, committee))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "new message returns 401", %{conn: conn, committee: committee} do
      conn = get(conn, Routes.committee_committee_message_path(conn, :new, committee))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "create message redirects returns 401", %{
      conn: conn,
      committee: committee
    } do
      attrs = valid_message_attrs(%{"committee_id" => committee.id})

      conn =
        post(conn, Routes.committee_committee_message_path(conn, :create, committee),
          message: attrs
        )

      assert html_response(conn, 401) =~ gettext("Access denied")
    end
  end

  describe "as a guest" do
    setup do
      committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      conn = build_conn()

      {:ok, conn: conn, committee: committee}
    end

    test "index lists all messages returns 401", %{conn: conn, committee: committee} do
      _message = message_fixture(%{"committee_id" => committee.id})
      conn = get(conn, Routes.committee_committee_message_path(conn, :index, committee))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "new message returns 401", %{conn: conn, committee: committee} do
      conn = get(conn, Routes.committee_committee_message_path(conn, :new, committee))
      assert html_response(conn, 401) =~ gettext("Access denied")
    end

    test "create message redirects returns 401", %{
      conn: conn,
      committee: committee
    } do
      attrs = valid_message_attrs(%{"committee_id" => committee.id})

      conn =
        post(conn, Routes.committee_committee_message_path(conn, :create, committee),
          message: attrs
        )

      assert html_response(conn, 401) =~ gettext("Access denied")
    end
  end

  # test "create message renders errors when data is invalid", %{conn: conn} do
  #   conn = post(conn, Routes.committee_committee_message_path(conn, :create), message: @invalid_attrs)
  #   assert html_response(conn, 200) =~ "New Message"
  # end

  # test "edit message renders form for editing chosen message", %{conn: conn, message: message} do
  #   conn = get(conn, Routes.committee_committee_message_path(conn, :edit, message))
  #   assert html_response(conn, 200) =~ "Edit Message"
  # end

  # test "update message redirects when data is valid", %{conn: conn, message: message} do
  #   conn = put(conn, Routes.committee_committee_message_path(conn, :update, message), message: @update_attrs)
  #   assert redirected_to(conn) == Routes.committee_committee_message_path(conn, :show, message)

  #   conn = get(conn, Routes.committee_committee_message_path(conn, :show, message))
  #   assert html_response(conn, 200) =~ "some updated body"
  # end

  # test "update message renders errors when data is invalid", %{conn: conn, message: message} do
  #   conn = put(conn, Routes.committee_committee_message_path(conn, :update, message), message: @invalid_attrs)
  #   assert html_response(conn, 200) =~ "Edit Message"
  # end

  # describe "delete message" do
  #   setup [:create_message]

  #   test "deletes chosen message", %{conn: conn, message: message} do
  #     conn = delete(conn, Routes.committee_committee_message_path(conn, :delete, message))
  #     assert redirected_to(conn) == Routes.committee_committee_message_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.committee_committee_message_path(conn, :show, message))
  #     end
  #   end
  # end
end
