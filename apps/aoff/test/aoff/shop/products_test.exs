defmodule AOFF.Shop.ProductsTest do
  use AOFF.DataCase

  alias AOFF.Shop
  import AOFF.Shop.ProductFixture

  describe "products" do
    alias AOFF.Shop.Product
    alias AOFF.Shop

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Shop.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Shop.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      attrs = create_product_attrs()
      assert {:ok, %Product{} = product} = Shop.create_product(attrs)
      assert product.description == attrs["description"]
      assert product.name == attrs["name"]
      assert product.price == attrs["price"]
    end

    test "create_product/1 with invalid data returns error changeset" do
      attrs = invalid_product_attrs()
      assert {:error, %Ecto.Changeset{}} = Shop.create_product(attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      attrs = update_product_attrs()
      assert {:ok, %Product{} = product} = Shop.update_product(product, attrs)
      assert product.description == attrs["description"]
      assert product.name == attrs["name"]
      assert product.price == attrs["price"]
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      attrs = invalid_product_attrs()
      assert {:error, %Ecto.Changeset{}} = Shop.update_product(product, attrs)
      assert product == Shop.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Shop.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Shop.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Shop.change_product(product)
    end
  end
end
