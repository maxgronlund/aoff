defmodule AOFFWeb.ErrorViewTest do
  use AOFFWeb.ConnCase, async: true

  import AOFFWeb.Gettext

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 401.html" do
    assert render_to_string(AOFFWeb.ErrorView, "401.html", []) =~ gettext("Access denied")
  end

  test "renders 404.html" do
    assert render_to_string(AOFFWeb.ErrorView, "404.html", []) =~ gettext("Not found")
  end

  test "renders 500.html" do
    assert render_to_string(AOFFWeb.ErrorView, "500.html", []) =~ gettext("Internal server error")
  end
end
