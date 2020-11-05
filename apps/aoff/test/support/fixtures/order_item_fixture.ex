defmodule AOFF.Users.OrderItemFixture do
  alias AOFF.Users

  @valid_attrs %{
    "state" => "initial",
    "price" => 1305
  }

  @update_attrs %{
    "state" => "delivered",
    "price" => 1205
  }

  @invalid_attrs %{
    "state" => nil,
    "price" => nil
  }

  def valid_order_item_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@valid_attrs)
  end

  def update_order_item_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@update_attrs)
  end

  def invalid_order_item_attrs(attrs \\ %{}) do
    attrs |> Enum.into(@invalid_attrs)
  end

  def order_item_fixture(attrs \\ %{}) do
    {:ok, order_item} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Users.create_order_item("public")

    order_item
  end
end
