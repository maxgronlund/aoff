defmodule AOFFWeb.Users.ConfirmationEmailControllerTest do
  use AOFFWeb.ConnCase
  import AOFF.Users.UserFixture

  test "render resend confirmation form", %{conn: conn} do
    conn = get(conn, Routes.confirmation_email_path(conn, :new))
  end

end