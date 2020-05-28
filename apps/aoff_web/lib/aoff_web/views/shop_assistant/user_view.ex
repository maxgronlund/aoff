defmodule AOFFWeb.ShopAssistant.UserView do
  use AOFFWeb, :view


  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end

  def valid_membership(user) do
    if user.expiration_date == nil do
      "Inactive"
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> "#{gettext("Valid member")}"
        :eq -> "#{gettext("Valid member")}"
        :lt -> "<div class='red'>#{gettext("Inactive")}</div>"
      end
    end
  end
end
