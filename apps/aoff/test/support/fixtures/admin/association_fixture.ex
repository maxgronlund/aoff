defmodule AOFF.Admin.AssociationFixture do
  alias AOFF.Admin

  @valid_attrs %{
    "name" => "ABC",
    "contact_person_1" => "some contact person 1",
    "contact_person_2" => "some contact person 2",
    "prefix" => "public",
    "host" => "localhost"
  }

  @update_attrs %{
    "name" => "DEF",
    "contact_person_1" => "some updated contact person 1",
    "contact_person_2" => "some updated contact person 2"
  }

  @invalid_attrs %{
    "name" => nil
  }

  def association_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_association_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_association_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def association_fixture(attrs \\ %{}) do
    {:ok, association} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Admin.create_association()

    association
  end
end
