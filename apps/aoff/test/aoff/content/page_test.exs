defmodule AOFF.PageTest do
  use AOFF.DataCase
  import AOFF.Content.CategoryFixture
  import AOFF.Content.PageFixture
  alias AOFF.Content

  alias AOFF.Content.Page

  describe "page" do
    test "get_page!/2 returns a single page" do
      category = category_fixture()
      page = page_fixture(category.id)
      assert Content.get_page!(category.title, page.title).id == page.id
    end

    test "create_page/1 with valid data creates a page" do
      category = category_fixture()
      attrs = create_page_attrs(%{"category_id" => category.id})
      assert {:ok, %Page{} = page} = Content.create_page(attrs)
      assert page.title == attrs["title"]
      assert page.text == attrs["text"]
    end

    # test "create_category/1 with invalid data returns error changeset" do
    #   attrs = invalid_category_attrs()
    #   assert {:error, %Ecto.Changeset{}} = Content.create_category(attrs)
    # end

    test "update_page/2 with valid data updates the page" do
      category = category_fixture()
      page = page_fixture(category.id)
      attrs = update_page_attrs()
      assert {:ok, %Page{} = page} = Content.update_page(page, attrs)
      assert page.title == attrs["title"]
      assert page.text == attrs["text"]
    end

    test "update_page/2 with invalid data returns error changeset" do
      category = category_fixture()
      page = page_fixture(category.id)
      attrs = invalid_page_attrs()
      assert {:error, %Ecto.Changeset{}} = Content.update_page(page, attrs)
      assert page.title == Content.get_page!(category.title, page.title).title
    end

    test "delete_page/1 deletes the page" do
      category = category_fixture()
      page = page_fixture(category.id)
      assert {:ok, %Page{}} = Content.delete_page(page)
      assert Content.get_page!(category.title, page.title) == nil
    end

    test "change_page/1 returns a page changeset" do
      assert %Ecto.Changeset{} = Content.change_page(%Page{})
    end
  end
end
