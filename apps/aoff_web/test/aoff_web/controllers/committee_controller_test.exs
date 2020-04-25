defmodule AOFFWeb.CommitteeControllerTest do
  use AOFFWeb.ConnCase

  alias AOFF.Committees

  import AOFF.Committees.CommitteeFixture



  describe "committee" do
    test "lists all committees", %{conn: conn} do
      conn = get(conn, Routes.committee_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Committees"
    end

    test "new committ renders form", %{conn: conn} do
      conn = get(conn, Routes.committee_path(conn, :new))
      assert html_response(conn, 200) =~ "New Committee"
    end

    test "create committee redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.committee_path(conn, :create), committee: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.committee_path(conn, :show, id)

      conn = get(conn, Routes.committee_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Committee"
    end

    test "create committee renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.committee_path(conn, :create), committee: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Committee"
    end

    test "edit committee renders form for editing chosen committee", %{conn: conn, committee: committee} do
      conn = get(conn, Routes.committee_path(conn, :edit, committee))
      assert html_response(conn, 200) =~ "Edit Committee"
    end

    test "update committee redirects when data is valid", %{conn: conn, committee: committee} do
      conn = put(conn, Routes.committee_path(conn, :update, committee), committee: @update_attrs)
      assert redirected_to(conn) == Routes.committee_path(conn, :show, committee)

      conn = get(conn, Routes.committee_path(conn, :show, committee))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "update committee renders errors when data is invalid", %{conn: conn, committee: committee} do
      conn = put(conn, Routes.committee_path(conn, :update, committee), committee: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Committee"
    end


    test "delete committee deletes chosen committee", %{conn: conn, committee: committee} do
      conn = delete(conn, Routes.committee_path(conn, :delete, committee))
      assert redirected_to(conn) == Routes.committee_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.committee_path(conn, :show, committee))
      end
    end
  end
end
