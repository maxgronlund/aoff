defmodule AOFFWeb.Committees.CommitteeViewTest do
  use AOFFWeb.ConnCase, async: true

  import AOFF.Users.UserFixture
  import AOFF.Committees.CommitteeFixture
  import AOFF.Committees.MemberFixture

  alias AOFF.Committees
  alias AOFFWeb.Committees.CommitteeView

  # Bring render/3 and render_to_string/3 for testing custom views
  # import Phoenix.View

  test "date/1 returns the date as a string" do
    assert CommitteeView.date(AOFF.Time.today()) ==
             AOFF.Time.today_as_string()
  end

  test "committee_member/2 returns false if the user isn't a member" do
    user = user_fixture()
    committee = committee_fixture()
    committee = Committees.get_committee!(committee.id)
    assert CommitteeView.committee_member(committee, user) == nil
  end

  test "committee_member/2 returns true if the user is a member" do
    user = user_fixture()
    committee = committee_fixture()

    _member =
      member_fixture(%{
        "user_id" => user.id,
        "committee_id" => committee.id
      })

    committee = Committees.get_committee!(committee.id)
    assert user.id == CommitteeView.committee_member(committee, user).user.id
  end
end
