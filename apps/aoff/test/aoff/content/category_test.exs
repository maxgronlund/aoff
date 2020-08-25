defmodule AOFF.CategoryTest do
  use AOFF.DataCase
  import AOFF.Content.CategoryFixture
  alias AOFF.Content

  alias AOFF.Content.Category

  describe "categories" do
    test "list_categories/1 returns all categories" do
      category = category_fixture()
      assert List.first(Content.list_categories()).id == category.id
    end

    test "get_category!/1 returns a single category" do
      category = category_fixture()
      assert Content.get_category!(category.title).id == category.id
    end

    test "create_category/1 with valid data creates a category" do
      attrs = create_category_attrs()
      assert {:ok, %Category{} = category} = Content.create_category(attrs)
      assert category.description == attrs["description"]
      assert category.title == attrs["title"]
    end

    test "create_category/1 with invalid data returns error changeset" do
      attrs = invalid_category_attrs()
      assert {:error, %Ecto.Changeset{}} = Content.create_category(attrs)
    end

    test "find_or_create_category/1 creates a category" do
      assert {:ok, %AOFF.Content.Category{}} = Content.find_or_create_category("Birds")
    end

    test "find_or_create_category/1 finds a category" do
      category = category_fixture()
      {:ok, cat} = Content.find_or_create_category(category.identifier)
      assert category.id == cat.id
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      attrs = update_category_attrs()
      assert {:ok, %Category{} = category} = Content.update_category(category, attrs)
      assert category.description == attrs["description"]
      assert category.title == attrs["title"]
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      attrs = invalid_category_attrs()
      assert {:error, %Ecto.Changeset{}} = Content.update_category(category, attrs)
      assert category.title == Content.get_category!(category.title).title
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Content.delete_category(category)
      assert Content.get_category!(category.title) == nil
    end

    # test "change_category/1 returns a category changeset" do
    #   category = category_fixture()
    #   assert %Ecto.Changeset{} = Categorys.change_category(category)
    # end
  end

  # describe "news" do
  #   test "list_news/0 returns all news" do
  #     news = news_fixture()
  #     assert Content.list_news() == [news]
  #   end

  #   test "get_news!/1 returns the news with given id" do
  #     news = news_fixture()
  #     assert Content.get_news!(news.id) == news
  #   end

  #   test "create_news/1 with valid data creates a news" do
  #     attrs = create_news_attrs()
  #     assert {:ok, %News{} = news} = Content.create_news(attrs)
  #     assert news.author == attrs["author"]
  #     assert news.caption == attrs["caption"]
  #     assert news.date == attrs["date"]
  #     assert news.text == attrs["text"]
  #     assert news.title == attrs["title"]
  #   end

  #   test "create_news/1 with invalid data returns error changeset" do
  #     attrs = invalid_news_attrs()
  #     assert {:error, %Ecto.Changeset{}} = Content.create_news(attrs)
  #   end

  #   test "update_news/2 with valid data updates the news" do
  #     news = news_fixture()
  #     attrs = update_news_attrs()
  #     assert {:ok, %News{} = news} = Content.update_news(news, attrs)
  #     assert news.author == attrs["author"]
  #     assert news.caption == attrs["caption"]
  #     assert news.date == attrs["date"]
  #     assert news.text == attrs["text"]
  #     assert news.title == attrs["title"]
  #   end

  #   test "update_news/2 with invalid data returns error changeset" do
  #     news = news_fixture()
  #     attrs = invalid_news_attrs()
  #     assert {:error, %Ecto.Changeset{}} = Content.update_news(news, attrs)
  #     assert news == Content.get_news!(news.id)
  #   end

  #   test "delete_news/1 deletes the news" do
  #     news = news_fixture()
  #     assert {:ok, %News{}} = Content.delete_news(news)
  #     assert_raise Ecto.NoResultsError, fn -> Content.get_news!(news.id) end
  #   end

  #   test "change_news/1 returns a news changeset" do
  #     news = news_fixture()
  #     assert %Ecto.Changeset{} = Content.change_news(news)
  #   end
  # end
end
