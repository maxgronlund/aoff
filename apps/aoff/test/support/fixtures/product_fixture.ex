defmodule AOFF.Shop.ProductFixture do
  alias AOFF.Shop

  @create_attrs %{
    "description" => "some description",
    "name" => "some name",
    "price" => Money.new(43, :DKK),
    "for_sale" => true,
    "membership" => false,
    "show_on_landing_page" => true
  }

  @update_attrs %{
    "description" => "some updated description",
    "name" => "some updated name",
    "price" => Money.new(45, :DKK),
    "for_sale" => false,
    "membership" => true,
    "show_on_landing_page" => false
  }

  @invalid_attrs %{
    "description" => nil,
    "name" => nil,
    "price" => nil,
    "for_sale" => nil,
    "membership" => nil,
    "show_on_landing_page" => nil
  }

  def create_product_attrs(attrs \\ %{}) do
    Enum.into(attrs, @create_attrs)
  end

  def update_product_attrs(attrs \\ %{}) do
    Enum.into(attrs, @update_attrs)
  end

  def invalid_product_attrs(attrs \\ %{}) do
    Enum.into(attrs, @invalid_attrs)
  end

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(@create_attrs)
      |> Shop.create_product()

    product
  end
end
