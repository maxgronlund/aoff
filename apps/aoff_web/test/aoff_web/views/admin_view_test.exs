defmodule AOFFWeb.Admin.AdminViewTest do
  use AOFFWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  # import Phoenix.View

  test "time/0 return a string" do
    AOFFWeb.Admin.AdminView.now()
    assert false
  end


end