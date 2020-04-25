defmodule AOFF.Committess.CommitteeFixture do
  alias AOFF.Committees

  @valid_attrs %{
    "name" => "some committee name",
    "description" => "some committee description",
    "identifier" => "some committe identifier"
  }

  @update_attrs %{
    "name" => "some updated committee name",
    "description" => "some updated committee description",
    "identifire" => "some updated committee identifire"
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
