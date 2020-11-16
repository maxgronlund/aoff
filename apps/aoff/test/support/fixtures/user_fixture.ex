defmodule AOFF.Users.UserFixture do
  @valid_attrs %{
    "username" => "some username",
    "member_nr" => 1,
    "email" => "some_username@example.com",
    "password" => "some-secret-password",
    "expiration_date" => Date.add(Date.utc_today(), 365),
    "months" => 12,
    "admin" => false,
    "volunteer" => false,
    "purchasing_manager" => false,
    "shop_assistant" => false,
    "mobile" => "12121212",
    "terms_accepted" => true,
    "registration_date" => Date.add(Date.utc_today(), -365),
    "subscribe_to_news" => "true"
  }

  @update_attrs %{
    "username" => "some other username",
    "member_nr" => 2,
    "email" => "some_updated_username@example.com",
    "password" => "some-updated-secret-password",
    "expiration_date" => Date.add(Date.utc_today(), 165),
    "months" => 12,
    "admin" => true,
    "volunteer" => true,
    "purchasing_manager" => true,
    "shop_assistant" => true,
    "mobile" => "23232323",
    "subscribe_to_news" => "false"
  }

  @attrs_without_pass %{
    "username" => "some other username",
    "member_nr" => 2,
    "email" => "some_updated_username@example.com",
    "expiration_date" => Date.add(Date.utc_today(), 165),
    "months" => 12,
    "admin" => true,
    "volunteer" => true,
    "purchasing_manager" => true,
    "shop_assistant" => true,
    "mobile" => "12121212"
  }

  @invalid_attrs %{
    "member_nr" => nil,
    "email" => nil,
    "password" => nil,
    "expiration_date" => nil,
    "months" => nil,
    "admin" => nil,
    "volunteer" => nil,
    "purchasing_manager" => nil,
    "shop_assistant" => nil,
    "mobile" => nil
  }

  def valid_attrs(), do: @valid_attrs

  def update_attrs(id, attrs \\ %{}) do
    attrs
    |> Enum.into(@update_attrs)
    |> Map.put("id", id)
  end

  def attrs_without_pass(id, attrs \\ %{}) do
    attrs
    |> Enum.into(@attrs_without_pass)
    |> Map.put("id", id)
  end

  def invalid_attrs(), do: @invalid_attrs

  def user_fixture(attrs \\ %{}) do
    attrs = Enum.into(attrs, @valid_attrs)
    {:ok, user} = AOFF.Volunteers.register_user("public", attrs)
    {:ok, user} = AOFF.Admin.Admins.update_user(user, attrs)
    user
  end

  def admin_fixture(attrs \\ %{}) do
    user = user_fixture(attrs)
    {:ok, user} = AOFF.Admin.Admins.update_user(user, attrs)
    user
  end
end
