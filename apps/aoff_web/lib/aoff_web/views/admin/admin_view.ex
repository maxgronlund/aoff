defmodule AOFFWeb.Admin.AdminView do
  use AOFFWeb, :view

  def now() do
    AOFF.Time.today_as_string()
  end
end
