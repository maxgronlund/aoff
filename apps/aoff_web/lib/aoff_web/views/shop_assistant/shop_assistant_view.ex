defmodule AOFFWeb.ShopAssistant.ShopAssistantView do
  use AOFFWeb, :view

  alias AOFF.Users

  def assistant_name(prefix, user_id) do
    if user_id do
      user = Users.get_user(prefix, user_id)
      gettext("%{username}: Mobile: %{mobile}", username: user.username, mobile: user.mobile)
    end
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end
end
