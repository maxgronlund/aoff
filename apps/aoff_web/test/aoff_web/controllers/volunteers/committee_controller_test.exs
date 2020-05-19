defmodule AOFFWeb.Volunteer.CommitteeControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  import AOFF.Users.UserFixture
  import AOFF.Committees.CommitteeFixture

  alias Plug.Conn


  describe "committee" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => true, "admin" => true})

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn}
    end

    test "lists all committees", %{conn: conn} do
      conn = get(conn, Routes.volunteer_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
    end

    test "new committ renders form", %{conn: conn} do
      conn = get(conn, Routes.volunteer_committee_path(conn, :new))
      assert html_response(conn, 200) =~ gettext("New Committee")
    end

    test "create committee redirects to show when data is valid", %{conn: conn} do
      attrs = valid_committee_attrs()
      conn = post(conn, Routes.volunteer_committee_path(conn, :create), committee: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_committee_path(conn, :show, id)

      conn = get(conn, Routes.volunteer_committee_path(conn, :show, id))
      assert html_response(conn, 200) =~ attrs["name"]
    end

    test "create committee renders errors when data is invalid", %{conn: conn} do
      attrs = invalid_committee_attrs()
      conn = post(conn, Routes.volunteer_committee_path(conn, :create), committee: attrs)
      assert html_response(conn, 200) =~ gettext("New Committee")
    end

    test "edit committee renders form for editing chosen committee", %{
      conn: conn
    } do
      committee = committee_fixture()
      conn = get(conn, Routes.volunteer_committee_path(conn, :edit, committee))
      assert html_response(conn, 200) =~ gettext("Edit Committee")
    end

    test "update committee redirects when data is valid", %{conn: conn} do
      committee = committee_fixture()
      attrs = update_committee_attrs()

      conn =
        put(conn, Routes.volunteer_committee_path(conn, :update, committee), committee: attrs)

      assert redirected_to(conn) == Routes.volunteer_committee_path(conn, :show, committee)

      conn = get(conn, Routes.volunteer_committee_path(conn, :show, committee))
      assert html_response(conn, 200) =~ attrs["description"]
    end

    test "update committee renders errors when data is invalid", %{
      conn: conn
    } do
      committee = committee_fixture()
      attrs = invalid_committee_attrs()

      conn =
        put(conn, Routes.volunteer_committee_path(conn, :update, committee), committee: attrs)

      assert html_response(conn, 200) =~ gettext("Edit Committee")
    end

    test "delete committee deletes chosen committee", %{conn: conn} do
      committee = committee_fixture()
      conn = delete(conn, Routes.volunteer_committee_path(conn, :delete, committee))
      assert redirected_to(conn) == Routes.volunteer_committee_path(conn, :index)

      # assert_error_sent 404, fn ->
      #   get(conn, Routes.volunteer_committee_path(conn, :show, committee))
      # end
    end
  end
end
