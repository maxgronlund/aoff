defmodule AOFFWeb.Purchaser.DateControllerTest do
  use AOFFWeb.ConnCase

  alias Plug.Conn
  import AOFF.Shop.DateFixture
  import AOFFWeb.Gettext
  import AOFF.Users.UserFixture
  import AOFF.Admin.AssociationFixture

  describe "volunteer" do
    @session Plug.Session.init(
               store: :cookie,
               key: "_app",
               encryption_salt: "yadayada",
               signing_salt: "yadayada"
             )

    setup do
      _association = association_fixture()
      user =
        user_fixture(%{
          "volunteer" => true,
          "purchasing_manager" => true
        })

      conn =
        build_conn()
        |> Plug.Session.call(@session)
        |> Conn.fetch_session()
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> assign(:prefix, "public")

      date = date_fixture()
      {:ok, conn: conn, date: date}
    end

    test "lists all dates", %{conn: conn} do
      conn = get(conn, Routes.purchaser_date_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Shoppinglists")
    end

    test "show date", %{conn: conn, date: date} do
      conn = get(conn, Routes.purchaser_date_path(conn, :show, date))

      assert html_response(conn, 200) =~
               gettext("Shopping list for: %{date}", date: date(date.date))
    end
  end

  defp date(date) do
    {:ok, date_as_string} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")

    case Date.compare(date, AOFF.Time.today()) do
      :lt ->
        "<div class=\"is-gray\">#{date_as_string}</div>"

      _ ->
        "#{date_as_string}"
    end
  end
end
