defmodule AOFFWeb.ShopAssistant.DateControllerTest do
  use AOFFWeb.ConnCase
  alias Plug.Conn

  import AOFF.Shop.DateFixture
  import AOFF.Users.UserFixture
  import AOFF.Admin.AssociationFixture
  import AOFFWeb.Gettext

  describe "shop assistant" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )
    setup do
      _association = association_fixture()
      user = user_fixture(%{"shop_assistant" => true})
      date = date_fixture()

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(:prefix, "public")

      {:ok, conn: conn, user: user, date: date}
    end

    test "lists all dates", %{conn: conn} do
      conn = get(conn, Routes.shop_assistant_date_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Arhcive")
    end

    test "show date", %{conn: conn, date: date} do
      conn = get(conn, Routes.shop_assistant_date_path(conn, :show, date))
      assert html_response(conn, 200) =~ gettext("Pickup lists")
    end

    # test "renders new product form", %{conn: conn} do
    #   conn = get(conn, Routes.purchaser_product_path(conn, :new))
    #   assert html_response(conn, 200) =~ gettext("New Product")
    # end

    # test "create new product redirects to edit when data is valid", %{conn: conn} do
    #   attrs = create_product_attrs(%{"price" => "13.5"})
    #   conn = post(conn, Routes.purchaser_product_path(conn, :create), product: attrs)

    #   assert %{id: id} = redirected_params(conn)
    #   assert redirected_to(conn) == Routes.purchaser_product_path(conn, :edit, id)

    #   conn = get(conn, Routes.purchaser_product_path(conn, :index))
    #   assert html_response(conn, 200) =~ attrs["name_da"]
    # end

    # test "create new product renders errors when data is invalid", %{conn: conn} do
    #   attrs = invalid_product_attrs(%{"price" => "1.0"})
    #   conn = post(conn, Routes.purchaser_product_path(conn, :create), product: attrs)
    #   assert html_response(conn, 200) =~ gettext("New Product")
    # end

    # test "edit product renders form for editing chosen product", %{conn: conn} do
    #   product = product_fixture()
    #   conn = get(conn, Routes.purchaser_product_path(conn, :edit, product))
    #   assert html_response(conn, 200) =~ gettext("Edit Product")
    # end

    # test "update product redirects when data is valid", %{conn: conn} do
    #   product = product_fixture()
    #   attrs = update_product_attrs(%{"price" => "1.5"})
    #   conn = put(conn, Routes.purchaser_product_path(conn, :update, product), product: attrs)
    #   assert redirected_to(conn) == Routes.purchaser_product_path(conn, :index)

    #   conn = get(conn, Routes.purchaser_product_path(conn, :show, product))
    #   assert html_response(conn, 200) =~ attrs["description_da"]
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   product = product_fixture()
    #   attrs = invalid_product_attrs(%{"price" => "1.0"})
    #   conn = put(conn, Routes.purchaser_product_path(conn, :update, product), product: attrs)
    #   assert html_response(conn, 200) =~ gettext("Edit Product")
    # end

    # test "deletes chosen product", %{conn: conn} do
    #   product = product_fixture()
    #   conn = delete(conn, Routes.purchaser_product_path(conn, :delete, product))
    #   assert redirected_to(conn) == Routes.purchaser_product_path(conn, :index)

    #   # assert_error_sent 404, fn ->
    #   #   get(conn, Routes.purchaser_product_path(conn, :show, product))
    #   # end
    # end
  end
end
