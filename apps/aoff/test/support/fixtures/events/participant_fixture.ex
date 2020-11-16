defmodule AOFF.Events.ParticipantFixture do
  alias AOFF.Events

  @valid_attrs %{
    "state" => "participating",
    "participants" => 1
  }

  @update_attrs %{
    "state" => "no",
    "participants" => 5
  }

  @invalid_attrs %{
    "state" => nil,
    "participants" => nil
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
    Events.create_participant("public", Enum.into(attrs, @valid_attrs))
  end
end
