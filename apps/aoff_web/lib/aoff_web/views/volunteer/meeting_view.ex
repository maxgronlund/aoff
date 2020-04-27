defmodule AOFFWeb.Volunteer.MeetingView do
  use AOFFWeb, :view



  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end
end
