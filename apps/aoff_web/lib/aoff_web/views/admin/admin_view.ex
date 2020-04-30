defmodule AOFFWeb.Admin.AdminView do
  use AOFFWeb, :view

  def now() do
    {:ok, date_time} = DateTime.now("Europe/Copenhagen")
    {:ok, time_now} = AOFFWeb.Cldr.DateTime.to_string(date_time, locale: "da")
    time_now
  end
end
