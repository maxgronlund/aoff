defmodule AOFF.Shop.DatesTest do
  use AOFF.DataCase

  alias AOFF.Shop
  alias AOFF.Shop.Date

  import AOFF.Shop.DateFixture
  import AOFF.Users.UserFixture

  describe "dates" do
    test "list_dates/0 returns all dates" do
      date = date_fixture()
      assert Shop.list_dates(date.date, "public") == [date]
    end

    test "get_date!/1 returns the date with given id" do
      date = date_fixture()
      assert Shop.get_date!(date.id, "public") == date
    end

    test "create_date/1 with valid data creates a date" do
      user_a = user_fixture(%{"email" => "user-a@example.com", "member_nr" => 3})
      user_b = user_fixture(%{"email" => "user-b@example.com", "member_nr" => 4})
      user_c = user_fixture(%{"email" => "user-c@example.com", "member_nr" => 5})
      user_d = user_fixture(%{"email" => "user-d@example.com", "member_nr" => 6})

      attrs =
        valid_date_attrs(%{
          "shop_assistant_a" => user_a.id,
          "shop_assistant_b" => user_b.id,
          "shop_assistant_c" => user_c.id,
          "shop_assistant_d" => user_d.id
        })

      assert {:ok, %Date{} = date} = Shop.create_date(attrs, "public")
      assert date.date == attrs["date"]
      assert date.shop_assistant_a == user_a.id
      assert date.shop_assistant_b == user_b.id
      assert date.shop_assistant_c == user_c.id
      assert date.shop_assistant_d == user_d.id
    end

    test "create_date/1 with invalid data returns error changeset" do
      attrs = invalid_date_attrs()
      assert {:error, %Ecto.Changeset{}} = Shop.create_date(attrs, "public")
    end

    test "update_date/2 with valid data updates the date" do
      date = date_fixture()
      attrs = update_date_attrs()
      assert {:ok, %Date{} = date} = Shop.update_date(date, attrs)
      assert date.date == attrs["date"]
    end

    test "update_date/2 with invalid data returns error changeset" do
      date = date_fixture()
      attrs = invalid_date_attrs()
      assert {:error, %Ecto.Changeset{}} = Shop.update_date(date, attrs)
      assert date == Shop.get_date!(date.id, "public")
    end

    test "delete_date/1 deletes the date" do
      date = date_fixture()
      assert {:ok, %Date{}} = Shop.delete_date(date)
      assert_raise Ecto.NoResultsError, fn -> Shop.get_date!(date.id, "public") end
    end

    test "change_date/1 returns a date changeset" do
      date = date_fixture()
      assert %Ecto.Changeset{} = Shop.change_date(date)
    end
  end
end
