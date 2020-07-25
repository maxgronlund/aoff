defmodule AOFF.Time do
  use Timex

  def now_as_string() do
    {:ok, time_now} =
      now()
      |> AOFFWeb.Cldr.DateTime.to_string(locale: Gettext.get_locale())

    time_now
  end

  def today_as_string() do
    {:ok, today} =
      today()
      |> AOFFWeb.Cldr.Date.to_string(locale: Gettext.get_locale())

    today
  end

  def now() do
    {:ok, date_time} = DateTime.now("Europe/Copenhagen")
    date_time
  end

  def today() do
    now() |> DateTime.to_date()
  end

  def date_as_string(date) do
    {:ok, date} = date |> AOFFWeb.Cldr.Date.to_string(locale: Gettext.get_locale())
    date
  end

  def time_as_string(time) do
    {:ok, time} = Timex.format(time, "{h24}:{0m}")
    time
  end

end
