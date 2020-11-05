defmodule AOFFWeb.Admin.UserControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext

  import AOFF.Users.UserFixture

  @username Application.get_env(:aoff_web, :basic_auth)[:username]
  @password Application.get_env(:aoff_web, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  describe "admin users" do
    setup do
      user = user_fixture(%{"admin" => true})

      conn =
        build_conn()
        |> using_basic_auth(@username, @password)
        |> assign(:prefix, "public")

      {:ok, conn: conn, user: user}
    end

    test "index show list of users", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Admin Users")
    end

    test "edit user renders form", %{conn: conn, user: user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ gettext("Edit User")
    end

    test "update user updates the given user", %{conn: conn, user: user} do
      attrs = update_attrs(user.id)
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: attrs)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)

      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200) =~ attrs["username"]
    end

    test "deletes chosen user", %{conn: conn} do
      delete_me_user =
        user_fixture(%{
          "member_nr" => 1234,
          "email" => "delete_me@example.com",
          "password" => "some password"
        })

      conn = delete(conn, Routes.admin_user_path(conn, :delete, delete_me_user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)
    end
  end
end
