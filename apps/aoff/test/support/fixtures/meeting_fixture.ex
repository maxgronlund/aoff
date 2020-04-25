defmodule AOFF.Committees.MeetingFixture do
  alias AOFF.Committees

  @valid_attrs %{
    "name" => "some meeting name",
    "description" => "some meeting description",
    "summary" => "some meeting summary"
  }

  @update_attrs %{
    "name" => "some updated meeting name",
    "description" => "some updated meeting description",
    "summary" => "some updated meeting summary"
  }

  @invalid_attrs %{
    "name" => nil,
    "description" => nil,
    "summary" => nil
  }

  def valid_meeting_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_meeting_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_meeting_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def meeting_fixture(attrs \\ %{}) do
    {:ok, meeting} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Committees.create_meeting()

    meeting
  end
end
