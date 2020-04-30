defmodule AOFF.Time do

  def now_as_string() do
    {:ok, time_now} =
      now()
      |> AOFFWeb.Cldr.DateTime.to_string(locale: "da")
    time_now
  end

  def today_as_string() do
    {:ok, today} =
      today()
      |> AOFFWeb.Cldr.Date.to_string(locale: "da")
    today
  end

  def now() do
    {:ok, date_time} = DateTime.now("Europe/Copenhagen")
    date_time
  end


  def today() do
    now() |> DateTime.to_date()
  end
end
