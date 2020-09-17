defmodule AOFFWeb.Users.ConfirmEmailControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture
  import AOFFWeb.Gettext
  alias AOFF.System
  alias AOFF.Users

  describe "confirm email" do
    test "render index when token is valid", %{conn: conn} do
      user = user_fixture()

      {:ok, user} =
        Users.set_password_reset_token(user, %{
          "password_reset_token" => Ecto.UUID.generate(),
          "password_reset_expires" => AOFF.Time.now()
        })

      conn = get(conn, Routes.user_confirm_email_path(conn, :index, user.password_reset_token))
      assert html_response(conn, 200) =~ gettext("Email confirmed")
    end

    test "render 404 token is invalid", %{conn: conn} do
      conn = get(conn, Routes.user_confirm_email_path(conn, :index, "invalid token"))
      assert html_response(conn, 404) =~ gettext("Not found")
    end

    test "render show when account not confirmed", %{conn: conn} do
      user = user_fixture()

      {:ok, message} =
        System.find_or_create_message(
          "Confirmation missing",
          "Confirmation missing",
          Gettext.get_locale()
        )

      conn = get(conn, Routes.confirm_email_path(conn, :show, user))
      assert html_response(conn, 200) =~ message.text
    end
  end
end
