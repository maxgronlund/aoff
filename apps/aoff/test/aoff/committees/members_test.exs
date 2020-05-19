defmodule AOFF.Committees.MembersTest do
  use AOFF.DataCase

  import AOFF.Committees.CommitteeFixture
  import AOFF.Committees.MemberFixture
  import AOFF.Users.UserFixture

  alias AOFF.Committees

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
