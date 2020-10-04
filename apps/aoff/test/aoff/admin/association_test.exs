defmodule AOFF.Admin.AssociationTest do
  use AOFF.DataCase

  alias AOFF.Admin

  import AOFF.Admin.AssociationFixture

  describe "associations" do
    alias AOFF.Admin.Association

    test "list_associations/0 returns all associations" do
      association = association_fixture()
      assert List.first(Admin.list_associations()).id == association.id
    end

    test "get_association!/1 returns the association with given id" do
      association = association_fixture()
      assert Admin.get_association!(association.id) == association
    end

    test "find_or_create_association/1 returns the association with given name" do
      name = "La la association"
      assert {:ok, %Association{} = association} = Admin.find_or_create_association(name)
      assert association.name == name
    end

    test "create_association/1 with valid data creates a association" do
      attrs = association_attrs()
      assert {:ok, %Association{} = association} = Admin.create_association(attrs)
      assert association.name == "some name"
    end

    test "create_association/1 with invalid data returns error changeset" do
      attrs = invalid_association_attrs()
      assert {:error, %Ecto.Changeset{}} = Admin.create_association(attrs)
    end

    test "update_association/2 with valid data updates the association" do
      association = association_fixture()
      attrs = update_association_attrs()
      assert {:ok, %Association{} = association} = Admin.update_association(association, attrs)
      assert association.name == attrs["name"]
    end

    test "update_association/2 with invalid data returns error changeset" do
      association = association_fixture()
      attrs = invalid_association_attrs()
      assert {:error, %Ecto.Changeset{}} = Admin.update_association(association, attrs)
      assert association == Admin.get_association!(association.id)
    end

    test "delete_association/1 deletes the association" do
      association = association_fixture()
      assert {:ok, %Association{}} = Admin.delete_association(association)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_association!(association.id) end
    end

    test "change_association/1 returns a association changeset" do
      association = association_fixture()
      assert %Ecto.Changeset{} = Admin.change_association(association)
    end
  end
end
