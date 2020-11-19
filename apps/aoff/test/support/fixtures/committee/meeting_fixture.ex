defmodule AOFF.Committees.MeetingFixture do
  alias AOFF.Committees

  @valid_attrs %{
    "name" => "some meeting name",
    "description" => "some meeting description",
    "summary" => "some meeting summary",
    "location" => "some location",
    "agenda" => "some agenda",
    "date" => Date.utc_today(),
    "time" => Time.utc_now()
  }

  @update_attrs %{
    "name" => "some updated meeting name",
    "description" => "some updated meeting description",
    "summary" => "some updated meeting summary",
    "location" => "some updated location",
    "agenda" => "some updated agenda",
    "date" => Date.add(Date.utc_today(), 12),
    "time" => Time.add(Time.utc_now(), 1234)
  }

  @invalid_attrs %{
    "name" => nil,
    "description" => nil,
    "summary" => nil,
    "location" => nil,
    "agenda" => nil,
    "date" => nil,
    "time" => nil
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
      Committees.create_meeting("public", Enum.into(attrs, @valid_attrs))
    meeting
  end
end
