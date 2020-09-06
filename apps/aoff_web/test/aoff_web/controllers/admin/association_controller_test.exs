defmodule AOFFWeb.Admin.AssociationControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  import AOFF.Admin.AssociationFixture

  @username Application.get_env(:aoff_web, :basic_auth)[:username]
  @password Application.get_env(:aoff_web, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  describe "index" do
    test "lists all associations", %{conn: conn} do
      conn =
        using_basic_auth(conn, @username, @password)
        |> get(Routes.admin_association_path(conn, :index))

      assert html_response(conn, 200) =~ gettext("Associations")
    end
  end

  describe "new association" do
    test "renders form", %{conn: conn} do
      conn =
        using_basic_auth(conn, @username, @password)
        |> get(Routes.admin_association_path(conn, :new))

      assert html_response(conn, 200) =~ gettext("New Association")
    end
  end

  describe "create association" do
    test "redirects to show when data is valid", %{conn: conn} do
      attrs = association_attrs()

      conn =
        using_basic_auth(conn, @username, @password)
        |> post(Routes.admin_association_path(conn, :create), association: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_association_path(conn, :show, id)

      conn = get(conn, Routes.admin_association_path(conn, :show, id))
      assert html_response(conn, 200) =~ attrs["name"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = invalid_association_attrs()

      conn =
        using_basic_auth(conn, @username, @password)
        |> post(Routes.admin_association_path(conn, :create), association: attrs)

      assert html_response(conn, 200) =~ gettext("New Association")
    end
  end

  describe "edit association" do
    test "renders form for editing chosen association", %{conn: conn} do
      association = association_fixture()

      conn =
        using_basic_auth(conn, @username, @password)
        |> get(Routes.admin_association_path(conn, :edit, association))

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
