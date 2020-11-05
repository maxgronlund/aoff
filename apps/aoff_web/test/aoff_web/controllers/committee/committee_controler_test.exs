defmodule AOFFWeb.Committees.CommitteeControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  import AOFF.Users.UserFixture
  import AOFF.Committees.CommitteeFixture
  import AOFF.Committees.MemberFixture

  alias Plug.Conn

  describe "as a guest" do
    test "lists public committess", %{conn: conn} do
      _hidden_committee = committee_fixture(%{"public_access" => false})
      public_committee = committee_fixture(%{"public_access" => true})
      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == [public_committee]
    end

    test "hide committees witout public access", %{conn: conn} do
      _volunteer_committee = committee_fixture(%{"public_access" => false})
      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == []
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

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(prefix: "public")

      {:ok, conn: conn, user: user}
    end

    test "lists public committess", %{conn: conn} do
      _hidden_committee =
        committee_fixture(%{
          "public_access" => false,
          "volunteer_access" => false,
          "member_access" => false
        })

      public_committee = committee_fixture(%{"public_access" => true})
      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == [public_committee]
    end

    test "lists volunteer committess", %{conn: conn} do
      _hidden_committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      volunteer_committee =
        committee_fixture(%{
          "volunteer_access" => true,
          "public_access" => false,
          "member_access" => false
        })

      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == [volunteer_committee]
    end

    test "lists committess where the user is a member", %{conn: conn, user: user} do
      committee_fixture(%{
        "volunteer_access" => false,
        "public_access" => false,
        "member_access" => false
      })

      committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == [committee]
    end

    test "hide committess where the user isn't a member", %{conn: conn} do
      _committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == []
    end
  end

  describe "as a member" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user = user_fixture(%{"volunteer" => false})

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn, user: user}
    end

    test "hide volunteer committess", %{conn: conn} do
      _volunteer_committee =
        committee_fixture(%{
          "volunteer_access" => false,
          "public_access" => false,
          "member_access" => false
        })

      conn = get(conn, Routes.committee_committee_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Listing Committees")
      assert conn.assigns.committees == []
    end
  end
end
