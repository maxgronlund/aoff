defmodule AOFF.Shop.PickUpFixture do
  alias AOFF.Shop

  @valid_attrs %{
    "picked_up" => false
  }

  @update_attrs %{
    "picked_up" => true
  }

  @invalid_attrs %{
    "picked_up" => nil
  }

  def valid_pick_up_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_pick_up_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_pick_up_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def pick_up_fixture(attrs \\ %{}) do
    {:ok, pick_up} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Shop.create_pick_up()

    pick_up
  end
end
