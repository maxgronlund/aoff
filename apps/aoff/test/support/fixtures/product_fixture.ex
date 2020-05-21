defmodule AOFF.Shop.ProductFixture do
  alias AOFF.Shop

  @create_attrs %{
    "description_da" => "some da description",
    "description_en" => "some en description",
    "name_da" => "some da name",
    "name_en" => "some en_dname",
    "this_weeks_content_da" => "some da this weeks content",
    "this_weeks_content_en" => "some en this weeks content",
    "price" => Money.new(43, :DKK),
    "for_sale" => true,
    "membership" => false,
    "show_on_landing_page" => true
  }

  @update_attrs %{
    "description_da" => "some updated da description",
    "description_en" => "some updated en description",
    "name_da" => "some updated da name",
    "name_en" => "some updated en name",
    "this_weeks_content_da" => "some updated da this weeks content",
    "this_weeks_content_en" => "some updated en this weeks content",
    "price" => Money.new(45, :DKK),
    "for_sale" => false,
    "show_on_landing_page" => false
  }

  @invalid_attrs %{
    "description_da" => nil,
    "description_en" => nil,
    "name_da" => nil,
    "name_en" => nil,
    "this_weeks_content_da" => nil,
    "this_weeks_content_en" => nil,
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
