defmodule AOFFWeb.Users.OrderView do
  use AOFFWeb, :view

  def open?(state) do
    case state do
      "open" -> true
      _ -> false
    end
  end

  def closed?(state) do
    !open?(state)
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end
end
