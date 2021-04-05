defmodule AOFFWeb.Admin.AssociationControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  import AOFF.Admin.AssociationFixture

  @username Application.get_env(:aoff_web, :basic_auth)[:username]
  @password Application.get_env(:aoff_web, :basic_auth)[:password]

  describe "admin associations" do
    setup do
      header_content = "Basic " <> Base.encode64("#{@username}:#{@password}")
      _association = association_fixture()

      conn =
        build_conn()
        |> assign(:prefix, "public")
        |> put_req_header("authorization", header_content)

      {:ok, conn: conn}
    end

    test "lists all", %{conn: conn} do
      conn = get(conn, Routes.admin_association_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Associations")
    end

    test "renders new form", %{conn: conn} do
      conn = get(conn, Routes.admin_association_path(conn, :new))

      assert html_response(conn, 200) =~ gettext("New Association")
    end

    test "create redirects to show when data is valid", %{conn: conn} do
      attrs = association_attrs()

      conn = post(conn, Routes.admin_association_path(conn, :create), association: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_association_path(conn, :show, id)

      conn = get(conn, Routes.admin_association_path(conn, :show, id))
      assert html_response(conn, 200) =~ attrs["name"]
    end

    test "create renders errors when data is invalid", %{conn: conn} do
      attrs = invalid_association_attrs()

      conn = post(conn, Routes.admin_association_path(conn, :create), association: attrs)

      assert html_response(conn, 200) =~ gettext("New Association")
    end

    test "edit renders form for editing chosen association", %{conn: conn} do
      association = association_fixture()

      conn = get(conn, Routes.admin_association_path(conn, :edit, association))

      assert html_response(conn, 200) =~ gettext("Edit Association")
    end
  end

  # describe "update association" do
  #   setup [:create_association]

  #   test "redirects when data is valid", %{conn: conn, association: association} do
  #     conn = put(conn, Routes.admin_association_path(conn, :update, association), association: @update_attrs)
  #     assert redirected_to(conn) == Routes.admin_association_path(conn, :show, association)

  #     conn = get(conn, Routes.admin_association_path(conn, :show, association))
  #     assert html_response(conn, 200) =~ "some updated name"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, association: association} do
  #     conn = put(conn, Routes.admin_association_path(conn, :update, association), association: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Association"
  #   end
  # end

  # describe "delete association" do
  #   setup [:create_association]

  #   test "deletes chosen association", %{conn: conn, association: association} do
  #     conn = delete(conn, Routes.admin_association_path(conn, :delete, association))
  #     assert redirected_to(conn) == Routes.admin_association_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.admin_association_path(conn, :show, association))
  #     end
  #   end
  # end
end
