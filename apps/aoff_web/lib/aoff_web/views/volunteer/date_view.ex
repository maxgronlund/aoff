defmodule AOFFWeb.Volunteer.DateView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end

  alias AOFF.Users

  @not_found "<i class='red'>" <> gettext("Missing host") <> "</i>"

  def shop_assistant(user_id) do
    cond do
      user_id == nil ->
        @not_found

      user = Users.get_user(user_id) ->
        # {user.mobile}"
        "<b>#{user.username}</b> - " <>
          gettext("Mobile: %{mobile}", mobile: user.mobile)

      true ->
        @not_found
    end
  end
end
