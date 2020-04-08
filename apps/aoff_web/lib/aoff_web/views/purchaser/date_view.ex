defmodule AOFFWeb.Purchaser.DateView do
  use AOFFWeb, :view

  alias AOFF.Users

  def assistant_name(user_id) do
    Users.username(user_id)
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end
end
