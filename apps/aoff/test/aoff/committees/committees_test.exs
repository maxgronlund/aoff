defmodule AOFF.CommitteesTest do
  use AOFF.DataCase

  import AOFF.Committees.CommitteeFixture
  import AOFF.Committees.MeetingFixture
  import AOFF.Committees.MemberFixture
  import AOFF.Users.UserFixture

  alias AOFF.Committees

  describe "committees" do
    alias AOFF.Committees.Committee

    test "list_committees/0 returns all committees" do
      committee = committee_fixture()
      assert Committees.list_committees() == [committee]
    end

    test "get_committee!/1 returns the committee with given id" do
      committee = committee_fixture()
      assert Committees.get_committee!(committee.id).id == committee.id
    end

    test "create_committee/1 with valid data creates a committee" do
      attrs = valid_committee_attrs()
      assert {:ok, %Committee{} = committee} = Committees.create_committee(attrs)
      assert committee.description == attrs["description"]
      assert committee.name == attrs["name"]
    end

    test "create_committee/1 with invalid data returns error changeset" do
      attrs = invalid_committee_attrs()
      assert {:error, %Ecto.Changeset{}} = Committees.create_committee(attrs)
    end

    test "update_committee/2 with valid data updates the committee" do
      committee = committee_fixture()
      attrs = update_committee_attrs()
      assert {:ok, %Committee{} = committee} = Committees.update_committee(committee, attrs)
      assert committee.description == attrs["description"]
      assert committee.name == attrs["name"]
    end

    test "update_committee/2 with invalid data returns error changeset" do
      committee = committee_fixture()
      attrs = invalid_committee_attrs()
      assert {:error, %Ecto.Changeset{}} = Committees.update_committee(committee, attrs)
      assert committee.id == Committees.get_committee!(committee.id).id
    end

    test "delete_committee/1 deletes the committee" do
      committee = committee_fixture()
      assert {:ok, %Committee{}} = Committees.delete_committee(committee)
      assert_raise Ecto.NoResultsError, fn -> Committees.get_committee!(committee.id) end
    end

    test "change_committee/1 returns a committee changeset" do
      committee = committee_fixture()
      assert %Ecto.Changeset{} = Committees.change_committee(committee)
    end
  end

  describe "meetings" do
    alias AOFF.Committees.Meeting

    setup do
      committee = committee_fixture()
      {:ok, committee: committee}
    end

    test "list_meetings/0 returns all meetings", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      assert Committees.list_meetings() == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      assert Committees.get_meeting!(meeting.id) == meeting
    end

    test "create_meeting/1 with valid data creates a meeting", %{committee: committee} do
      attrs = valid_meeting_attrs(%{"committee_id" => committee.id})
      assert {:ok, %Meeting{} = meeting} = Committees.create_meeting(attrs)
      assert meeting.description == attrs["description"]
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
      assert meeting.description == attrs["description"]
      assert meeting.name == attrs["name"]
      assert meeting.summary == attrs["summary"]
    end

    test "update_meeting/2 with invalid data returns error changeset", %{committee: committee} do
      meeting = meeting_fixture(%{"committee_id" => committee.id})
      attrs = invalid_meeting_attrs()
      assert {:error, %Ecto.Changeset{}} = Committees.update_meeting(meeting, attrs)
      assert meeting == Committees.get_meeting!(meeting.id)
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

  describe "members" do
    alias AOFF.Committees.Member

    setup do
      user = user_fixture()
      committee = committee_fixture()
      {:ok, user: user, committee: committee}
    end

    test "list_members/0 returns all members", %{user: user, committee: committee} do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      assert Committees.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id", %{user: user, committee: committee} do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      assert Committees.get_member!(member.id).id == member.id
    end

    test "create_member/1 with valid data creates a member", %{user: user, committee: committee} do
      attrs = valid_member_attrs(%{"user_id" => user.id, "committee_id" => committee.id})
      assert {:ok, %Member{} = member} = Committees.create_member(attrs)
      assert member.role == "some role"
    end

    test "create_member/1 with invalid data returns error changeset", %{user: user} do
      attrs = invalid_member_attrs(%{"user_id" => user.id})
      assert {:error, %Ecto.Changeset{}} = Committees.create_member(attrs)
    end

    test "update_member/2 with valid data updates the member", %{user: user, committee: committee} do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      attrs = update_member_attrs()
      assert {:ok, %Member{} = member} = Committees.update_member(member, attrs)
      assert member.role == "some updated role"
    end

    test "delete_member/1 deletes the member", %{user: user, committee: committee} do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      assert {:ok, %Member{}} = Committees.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Committees.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset", %{user: user, committee: committee} do
      member = member_fixture(%{"user_id" => user.id, "committee_id" => committee.id})
      assert %Ecto.Changeset{} = Committees.change_member(member)
    end


  end
end
