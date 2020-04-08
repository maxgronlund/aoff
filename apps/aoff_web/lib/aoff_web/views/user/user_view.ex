defmodule AOFFWeb.UserView do
  use AOFFWeb, :view

  def valid_membership(user) do
    if user.expiration_date == nil do
      ""
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> "√"
        :lt -> ""
      end
    end
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end

end
