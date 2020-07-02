defmodule AOFF.Committees.MeetingsTest do
  use AOFF.DataCase

  import AOFF.Committees.CommitteeFixture
  import AOFF.Committees.MeetingFixture
  import AOFF.Users.UserFixture
  import AOFF.Committees.MemberFixture

  alias AOFF.Committees

  describe "meetings" do
    alias AOFF.Committees.Meeting

    setup do
      committee = committee_fixture()
      {:ok, committee: committee}
    end

    test "list_user_meetings/3 returns all upcomming meetings for a given user", %{committee: committee} do
      user = user_fixture()
      _member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      meeting =
        meeting_fixture(
          %{
            "committee_id" => committee.id,
            "date" => Date.add(Date.utc_today(), 5)
          }
        )
      meetings = Committees.list_user_meetings(user.id, Date.utc_today())
      assert List.first(meetings).id == meeting.id
    end

    test "list_user_meetings/3 returns false if no upcomming meetings for a given user exists",
      %{committee: committee} do
      user = user_fixture()
      _member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      _meeting =
        meeting_fixture(
          %{
            "committee_id" => committee.id,
            "date" => Date.add(Date.utc_today(), -5)
          }
        )
      meetings = Committees.list_user_meetings(user.id, Date.utc_today())
      assert  meetings == false
    end

    test "list_meetings/1 returns all meetings for a given commitee", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      assert Committees.list_meetings() == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      assert Committees.get_meeting!(meeting.id).id == meeting.id
    end

    test "create_meeting/1 with valid data creates a meeting", %{committee: committee} do
      attrs = valid_meeting_attrs(%{"committee_id" => committee.id})
      assert {:ok, %Meeting{} = meeting} = Committees.create_meeting(attrs)
      assert meeting.agenda == attrs["agenda"]
      assert meeting.name == attrs["name"]
      assert meeting.summary == attrs["summary"]
    end

    test "create_meeting/1 with invalid data returns error changeset", %{committee: committee} do
      attrs = invalid_meeting_attrs(%{"committee_id" => committee.id})
      assert {:error, %Ecto.Changeset{}} = Committees.create_meeting(attrs)
    end

    test "update_meeting/2 with valid data updates the meeting", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      attrs = update_meeting_attrs()
      assert {:ok, %Meeting{} = meeting} = Committees.update_meeting(meeting, attrs)
      assert meeting.agenda == attrs["agenda"]
      assert meeting.name == attrs["name"]
      assert meeting.summary == attrs["summary"]
    end

    test "update_meeting/2 with invalid data returns error changeset", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      attrs = invalid_meeting_attrs()
      assert {:error, %Ecto.Changeset{}} = Committees.update_meeting(meeting, attrs)
      # assert meeting == Committees.get_meeting!(meeting.id)
    end

    test "delete_meeting/1 deletes the meeting", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      assert {:ok, %Meeting{}} = Committees.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> Committees.get_meeting!(meeting.id) end
    end

    test "change_meeting/1 returns a meeting changeset", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})

      assert %Ecto.Changeset{} = Committees.change_meeting(meeting)
    end
  end
end
