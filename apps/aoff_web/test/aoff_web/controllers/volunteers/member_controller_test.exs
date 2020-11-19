defmodule AOFFWeb.Committees.MemberControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Committees.MemberFixture
  import AOFF.Committees.CommitteeFixture
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext

  alias Plug.Conn

  describe "volunteer" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => true})

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(prefix: "public")

      committee = committee_fixture()

      {:ok, conn: conn, user: user, committee: committee}
    end

    test "new member renders form", %{conn: conn, committee: committee} do
      conn = get(conn, Routes.volunteer_committee_member_path(conn, :new, committee))
      assert html_response(conn, 200) =~ gettext("New Member")
    end

    test "create member redirects to show when data is valid", %{
      conn: conn,
      user: user,
      committee: committee
    } do
      attrs = valid_member_attrs(%{"committee_id" => committee.id, "user_id" => user.id})

      conn =
        post(conn, Routes.volunteer_committee_member_path(conn, :create, committee), member: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.committee_committee_path(conn, :show, committee)

      conn = get(conn, Routes.committee_committee_path(conn, :show, committee))
      assert html_response(conn, 200) =~ attrs["role"]
    end

    test "renders errors when data is invalid", %{conn: conn, committee: committee} do
      attrs = invalid_member_attrs(%{"committee_id" => committee.id})

      conn =
        post(conn, Routes.volunteer_committee_member_path(conn, :create, committee), member: attrs)

      assert html_response(conn, 200) =~ gettext("New Member")
    end

    test "edit member renders form for editing chosen member", %{
      conn: conn,
      user: user,
      committee: committee
    } do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      conn = get(conn, Routes.volunteer_committee_member_path(conn, :edit, committee, member))
      assert html_response(conn, 200) =~ gettext("Edit Member")
    end

    test "update member redirects when data is valid", %{
      conn: conn,
      user: user,
      committee: committee
    } do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      attrs = update_member_attrs()

      conn =
        put(conn, Routes.volunteer_committee_member_path(conn, :update, committee, member),
          member: attrs
        )

      assert redirected_to(conn) == Routes.committee_committee_path(conn, :show, committee)

      conn = get(conn, Routes.committee_committee_path(conn, :show, committee))
      assert html_response(conn, 200) =~ attrs["role"]
    end

    test "update member renders errors when data is invalid", %{
      conn: conn,
      user: user,
      committee: committee
    } do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      attrs = invalid_member_attrs()

      conn =
        put(
          conn,
          Routes.volunteer_committee_member_path(conn, :update, committee, member),
          member: attrs
        )

      assert html_response(conn, 200) =~ gettext("Edit Member")
    end

    test "delete member deletes chosen member", %{conn: conn, user: user, committee: committee} do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})

      conn =
        delete(conn, Routes.volunteer_committee_member_path(conn, :delete, committee, member))

      assert redirected_to(conn) == Routes.committee_committee_path(conn, :show, committee)
    end
  end
end
