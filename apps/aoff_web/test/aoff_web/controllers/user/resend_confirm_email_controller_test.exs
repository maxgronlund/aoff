defmodule AOFFWeb.ResendConfirmEmailControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture
  alias AOFF.System

  describe "resend email confirmation email" do
    test "render new", %{conn: conn} do
      {:ok, message} =
        System.find_or_create_message(
          "Resend confirmation email",
          "Resend confirmation email",
          Gettext.get_locale()
        )

      conn = get(conn, Routes.resend_confirm_email_path(conn, :new))
      assert html_response(conn, 200) =~ message.title
    end

    test "create", %{conn: conn} do
      user = user_fixture()
      attrs = %{"user" => %{"email" => user.email}}
      conn = post(conn, Routes.resend_confirm_email_path(conn, :create, attrs))
      assert redirected_to(conn) == Routes.resend_confirm_email_path(conn, :index)
    end

    test "index", %{conn: conn} do
      {:ok, message} =
        System.find_or_create_message(
          "Confirmation email was resend",
          "Confirmation email was resend",
          Gettext.get_locale()
        )

      conn = get(conn, Routes.resend_confirm_email_path(conn, :index, %{}))
      assert html_response(conn, 200) =~ message.title
    end
  end
end
