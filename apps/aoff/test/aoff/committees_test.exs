defmodule AOFF.CommitteesTest do
  use AOFF.DataCase

  alias AOFF.Committees

  describe "members" do
    alias AOFF.Committees.Member

    @valid_attrs %{role: "some role"}
    @update_attrs %{role: "some updated role"}
    @invalid_attrs %{role: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Committees.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Committees.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Committees.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Committees.create_member(@valid_attrs)
      assert member.role == "some role"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Committees.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Committees.update_member(member, @update_attrs)
      assert member.role == "some updated role"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Committees.update_member(member, @invalid_attrs)
      assert member == Committees.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Committees.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Committees.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Committees.change_member(member)
    end
  end
end
