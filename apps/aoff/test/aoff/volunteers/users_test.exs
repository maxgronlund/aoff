defmodule AOFF.Volunteer.UsersTest do
  use AOFF.DataCase

  alias AOFF.Volunteers

  import AOFF.Users.UserFixture

  alias AOFF.Users

  describe "users" do
    alias AOFF.Users.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert List.first(Volunteers.list_users("public")).id == user.id
    end

    test "list_shop_assistans/0 returns all shop_assistans" do
      user = user_fixture(%{"shop_assistant" => true})

      assert List.first(Volunteers.list_shop_assistans("public")).id == user.id
    end

    test "username/1 returns the username for a given shop_assistans" do
      user = user_fixture(%{"shop_assistant" => true, "username" => "assistant 1"})

      assert Volunteers.username("public", user.id) == user.username
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Volunteers.get_user!("public", user.id).id == user.id
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      attrs = invalid_attrs()

      assert {:error, %Ecto.Changeset{}} = Volunteers.update_user(user, attrs)
      assert user.id == Volunteers.get_user!("public", user.id).id
    end

    test "update_user/2 set confirmed at" do
      user = user_fixture()
      attrs = Map.put(valid_attrs(), "confirm_account", true)

      {:ok, %AOFF.Users.User{} = user} = Volunteers.update_user(user, attrs)

      refute is_nil(user.confirmed_at)
    end

    test "update_user/2 dont set confirmed at" do
      user = user_fixture()
      attrs = valid_attrs()
      {:ok, %AOFF.Users.User{} = user} = Volunteers.update_user(user, attrs)

      assert is_nil(user.confirmed_at)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Volunteers.change_user(user)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Volunteers.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Volunteers.get_user!("public", user.id) end
    end

    test "member_count/1 return how many members there are" do
      _user = user_fixture()
      assert Users.member_count("public", :all) == 1
    end

    test "member_count/1 return how many valid members there are" do
      _user = user_fixture()
      assert Users.member_count("public", :valid) == 1
    end

    test "member_count/1 return how many newsletter subscribers there are" do
      _user = user_fixture(%{"subscribe_to_news" => false})
      assert Users.member_count("public", :subscribers) == 0
    end
  end
end
