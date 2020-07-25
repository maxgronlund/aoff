defmodule AOFFWeb.Committees.MeetingView do
  use AOFFWeb, :view

  def date_time(committee) do
    AOFF.Time.date_time_as_string(committee.date, committee.time)
  end

  def committee_member(committee, current_user) do
    if current_user do
      Enum.find(committee.members, fn x -> x.user_id == current_user.id end)
    else
      false
    end
  end
end
