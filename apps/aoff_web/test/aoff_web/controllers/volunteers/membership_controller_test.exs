defmodule AOFFWeb.Volunteers.CategoryControllerTest do
  use AOFFWeb.ConnCase
  import AOFFWeb.Gettext

  alias Plug.Conn

  import AOFF.Content.CategoryFixture
  import AOFF.Users.UserFixture

  describe "volunteer" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      user =
        user_fixture(
          %{
            "volunteer" => true,
            "manage_membership" => true
          }
        )

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)

      {:ok, conn: conn}
    end

    test "lists all memberships", %{conn: conn} do
      conn = get(conn, Routes.volunteer_membership_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Memberships")
    end
  end

  # describe "admin" do
  #   @session Plug.Session.init(
  #              store: :cookie,
  #              key: "_app",
  #              encryption_salt: "yadayada",
  #              signing_salt: "yadayada"
  #            )
  #   setup do
  #     user = user_fixture(%{"admin" => true})

  #     conn =
  #       build_conn()
  #       |> Plug.Session.call(@session)
  #       |> Conn.fetch_session()
  #       |> put_session(:user_id, user.id)
  #       |> configure_session(renew: true)

  #     {:ok, conn: conn}
  #   end

  #   test "lists all categories", %{conn: conn} do
  #     conn = get(conn, Routes.volunteer_category_path(conn, :index))
  #     assert html_response(conn, 200) =~ gettext("Categories")
  #   end

  #   test "new category renders form", %{conn: conn} do
  #     conn = get(conn, Routes.volunteer_category_path(conn, :new))
  #     assert html_response(conn, 200) =~ gettext("New Category")
  #   end

  #   test "create category redirects to edit when data is valid", %{conn: conn} do
  #     attrs = create_category_attrs()
  #     conn = post(conn, Routes.volunteer_category_path(conn, :create), category: attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.volunteer_category_path(conn, :edit, attrs["title"])

  #     # conn = get(conn, Routes.about_path(conn, :show, id))
  #     # assert html_response(conn, 200) =~ attrs["title"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     attrs = invalid_category_attrs()
  #     conn = post(conn, Routes.volunteer_category_path(conn, :create), category: attrs)
  #     assert html_response(conn, 200) =~ gettext("New Category")
  #   end

  #   test "edit category renders form for editing chosen category", %{conn: conn} do
  #     category = category_fixture()
  #     conn = get(conn, Routes.volunteer_category_path(conn, :edit, category))
  #     assert html_response(conn, 200) =~ gettext("Edit Category")
  #   end

  #   test "update category redirects when data is valid", %{conn: conn} do
  #     category = category_fixture()
  #     attrs = update_category_attrs()
  #     conn = put(conn, Routes.volunteer_category_path(conn, :update, category), category: attrs)
  #     assert redirected_to(conn) == Routes.volunteer_category_path(conn, :index)

  #     # conn = get(conn, Routes.volunteer_category_path(conn, :show, category))
  #     # assert html_response(conn, 200) =~ attrs["description"]
  #   end

  #   test "update category renders errors when data is invalid", %{conn: conn} do
  #     category = category_fixture()
  #     attrs = invalid_category_attrs()
  #     conn = put(conn, Routes.volunteer_category_path(conn, :update, category), category: attrs)
  #     assert html_response(conn, 200) =~ gettext("Edit Category")
  #   end

  #   test "deletes chosen category", %{conn: conn} do
  #     category = category_fixture()
  #     conn = delete(conn, Routes.volunteer_category_path(conn, :delete, category))
  #     assert redirected_to(conn) == Routes.volunteer_category_path(conn, :index)
  #   end
  # end
end
