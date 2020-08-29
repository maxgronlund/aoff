defmodule AOFF.Committees.CommitteeFixture do
  alias AOFF.Committees

  @valid_attrs %{
    "name" => "some committee name",
    "description" => "some committee description",
    "identifier" => "some committe identifier",
    "public_access" => true,
    "volunteer_access" => true,
    "member_access" => true,
    "enable_meetings" => true
  }

  @update_attrs %{
    "name" => "some updated committee name",
    "description" => "some updated committee description",
    "identifire" => "some updated committee identifire",
    "public_access" => false,
    "volunteer_access" => false,
    "member_access" => false,
    "enable_meetings" => false
  }

  @invalid_attrs %{
    "name" => nil,
    "description" => nil,
    "identifire" => nil
  }

  def valid_committee_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_committee_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_committee_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def committee_fixture(attrs \\ %{}) do
    {:ok, committee} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Committees.create_committee()

    committee
  end
end
