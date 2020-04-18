defmodule AOFFWeb.Volunteer.DateControllerTest do
  use AOFFWeb.ConnCase

  alias Plug.Conn
  import AOFF.Shop.DateFixture
  import AOFFWeb.Gettext
  import AOFF.Users.UserFixture

  describe "volunteer dates" do
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

      date = date_fixture()
      {:ok, conn: conn, date: date}
    end

    test "lists all dates", %{conn: conn} do
      conn = get(conn, Routes.volunteer_date_path(conn, :index))
      assert html_response(conn, 200) =~ gettext("Opening dates")
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.volunteer_date_path(conn, :new))
      assert html_response(conn, 200) =~ gettext("New Date")
    end

    test "create date redirects to show when data is valid", %{conn: conn} do
      attrs = valid_date_attrs(%{"date" => Date.add(Date.utc_today(), 165)})
      conn = post(conn, Routes.volunteer_date_path(conn, :create), date: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.volunteer_date_path(conn, :show, id)

      conn = get(conn, Routes.volunteer_date_path(conn, :show, id))
      assert html_response(conn, 200) =~ gettext("Early shift")
    end

    test "create date renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.volunteer_date_path(conn, :create), date: invalid_date_attrs())
      assert html_response(conn, 200) =~ gettext("New Date")
    end

    test "edit date renders form for editing chosen date", %{conn: conn, date: date} do
      conn = get(conn, Routes.volunteer_date_path(conn, :edit, date))
      assert html_response(conn, 200) =~ gettext("Edit Date")
    end

    test "update date redirects when data is valid", %{conn: conn, date: date} do
      conn =
        put(
          conn,
          Routes.volunteer_date_path(conn, :update, date),
          date: update_date_attrs()
        )

      assert redirected_to(conn) == Routes.volunteer_date_path(conn, :show, date)

      conn = get(conn, Routes.volunteer_date_path(conn, :show, date))
      assert html_response(conn, 200)
    end

    test "update date renders errors when data is invalid", %{conn: conn, date: date} do
      conn =
        put(conn, Routes.volunteer_date_path(conn, :update, date), date: invalid_date_attrs())

      assert html_response(conn, 200) =~ "Edit Date"
    end

    test "delete date deletes chosen date", %{conn: conn, date: date} do
      conn = delete(conn, Routes.volunteer_date_path(conn, :delete, date))
      assert redirected_to(conn) == Routes.volunteer_date_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.volunteer_date_path(conn, :show, date))
      end
    end
  end
end
