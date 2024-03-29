defmodule AOFFWeb.Volunteer.DateView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  alias AOFF.Users

  @not_found "<i class='red'>" <> gettext("Missing host") <> "</i>"

  # TODO: bad design accessing the DB From a view
  def shop_assistant(user_id, prefix) do
    cond do
      user_id == nil ->
        @not_found

      user = Users.get_user(prefix, user_id) ->
        # {user.mobile}"
        "<b>#{user.username}</b> - " <>
          gettext("Mobile: %{mobile}", mobile: user.mobile)

      true ->
        @not_found
    end
  end

  def shift_time(from_time, to_time) do
    gettext(
      " - %{from} to %{to}",
      from: AOFF.Time.time_as_string(from_time),
      to: AOFF.Time.time_as_string(to_time)
    )
  end
end
