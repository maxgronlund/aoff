defmodule AOFFWeb.Committees.CommitteeView do
  use AOFFWeb, :view

  def date(date) do
    {:ok, date} = AOFFWeb.Cldr.Date.to_string(date, locale: Gettext.get_locale())
    date
  end

  def committee_member(committee, current_user) do
    if current_user do
      Enum.find(committee.members, fn x -> x.user_id == current_user.id end)
    else
      false
    end
  end
end
