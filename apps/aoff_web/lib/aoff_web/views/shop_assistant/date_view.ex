defmodule AOFFWeb.ShopAssistant.DateView do
  use AOFFWeb, :view

  @not_found  "<b class='red'>#{gettext("Missing host")}</b>
        <br/>" <> "-" <>
        "<br/>" <> "-"

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: "da")
    date
  end

  alias AOFF.Users

  def shop_assistant(user_id) do
    cond do
      user_id == nil ->
        @not_found
      user = Users.get_user(user_id) ->
        "<b>#{user.username}</b>
        <br/>" <> gettext("Email: %{email}", email: user.email) <>
        "<br/>" <> gettext("Mobile: %{mobile}", mobile: user.mobile)
      true ->
        @not_found
    end
  end
end
