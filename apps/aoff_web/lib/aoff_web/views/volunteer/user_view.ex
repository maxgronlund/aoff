defmodule AOFFWeb.Volunteer.UserView do
  use AOFFWeb, :view

  def valid_membership(user) do
    if user.expiration_date == nil do
      gettext("Inactive membership")
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> gettext("Valid member")
        :lt -> gettext("Inactive membership")
        :eq -> gettext("Valid member")
      end
    end
  end

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  def valid?(user) do
    if user.expiration_date == nil do
      false
    else
      case Date.compare(user.expiration_date, Date.utc_today()) do
        :gt -> true
        :lt -> false
        :eq -> true
      end
    end
  end

  alias AOFF.Users

  @not_found "<i class='red'>" <> gettext("Missing host") <> "</i>"

  def shop_assistant(user_id, prefix) do
    cond do
      user_id == nil ->
        @not_found

      user = Users.get_user(user_id, prefix) ->
        # {user.mobile}"
        "<b>#{user.username}</b> - " <>
          "<br/>" <>
          gettext("Mobile: %{mobile}", mobile: user.mobile)

      true ->
        @not_found
    end
  end
end
