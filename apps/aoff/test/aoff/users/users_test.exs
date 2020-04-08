defmodule AOFF.UsersTest do
  use AOFF.DataCase

  alias AOFF.Users

  import AOFF.Users.UserFixture

  describe "users" do
    alias AOFF.Users.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert List.first(Users.list_users()).id == user.id
    end

    test "list_shop_assistans/0 returns all shop_assistans" do
      user = user_fixture(%{"shop_assistans" => true})
      assert List.first(Users.list_users()).id == user.id
    end

    test "username/1 returns the username for a given shop_assistans" do
      user = user_fixture(%{"shop_assistans" => true, "username" => "assistant 1"})

      assert Users.username(user.id) == user.username
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id).id == user.id
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()

      assert Users.get_user_by_email(user.email).id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      attrs = valid_attrs()

      assert {:ok, %User{} = user} = Users.create_user(attrs)

      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(invalid_attrs())
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      attrs = update_attrs(user.id)
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)
      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "update_user/2 with valid data without password updates the user" do
      user = user_fixture()
      attrs = attrs_without_pass(user.id)
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)
      assert user.username == attrs["username"]
      assert user.email == attrs["email"]
      assert user.mobile == attrs["mobile"]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      attrs = invalid_attrs()

      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, attrs)
      assert user.id == Users.get_user!(user.id).id
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    # test "last_member_nr/0 returne the last member_nr" do
    #   _user = user_fixture()
    #   user = user_fixture(%{"member_nr" => 2})
    #   assert Users.last_member_nr() == user.member_nr
    # end
  end
end
