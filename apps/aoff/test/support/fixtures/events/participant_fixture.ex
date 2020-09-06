defmodule AOFF.Events.ParticipantFixture do
  alias AOFF.Events

  @valid_attrs %{
    "state" => "participating"
  }

  @update_attrs %{
    "state" => "cancelled"
  }

  @invalid_attrs %{
    "state" => nil
  }

  def valid_participant_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_participant_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_participant_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def participant_fixture(attrs \\ %{}) do
    {:ok, participant} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Events.create_participant()
  end
end
