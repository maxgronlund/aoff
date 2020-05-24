defmodule AOFF.Committees.MemberFixture do
  alias AOFF.Committees

  @valid_attrs %{
    "role" => "some role"
  }

  @update_attrs %{
    "role" => "some updated role"
  }

  @invalid_attrs %{
    "role" => nil
  }

  def valid_member_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_member_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_member_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def member_fixture(attrs \\ %{}) do
    {:ok, meeting} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Committees.create_member()

    meeting
  end
end
