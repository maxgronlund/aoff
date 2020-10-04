defmodule AOFFWeb.Committees.MessageView do
  use AOFFWeb, :view

  def date(date) do
    AOFF.Time.date_as_string(date)
  end

  def time(date) do
    AOFF.Time.time_as_string(date)
  end
end
