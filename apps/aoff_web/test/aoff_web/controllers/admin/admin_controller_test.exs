defmodule AOFFWeb.OrderControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext
  alias Plug.Conn

  @username Application.get_env(:aoff_web, :basic_auth)[:username]
  @password Application.get_env(:aoff_web, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  describe "in the admin namespace" do
    test "render index", %{conn: conn} do
      conn =
        conn
        |> using_basic_auth(@username, @password)
        |> get("/admin")

      assert html_response(conn, 200) =~ gettext("Admin")
    end
  end
end
