defmodule AOFF.ContentTest do
  use AOFF.DataCase
  import AOFF.Content.NewsFixture
  alias AOFF.Content
  alias AOFF.Content.News

  describe "news" do
    test "list_news/0 returns all news" do
      news = news_fixture()
      assert Content.list_news() == [news]
    end

    test "latest_news/0 return latest news" do
      news = news_fixture()
      assert Content.latest_news() == [news]
    end

    test "get_news!/1 returns the news with given id" do
      news = news_fixture()
      assert Content.get_news!(news.id) == news
    end

    test "create_news/1 with valid data creates a news" do
      attrs = create_news_attrs()
      assert {:ok, %News{} = news} = Content.create_news(attrs)
      assert news.author == attrs["author"]
      assert news.caption == attrs["caption"]
      assert news.date == attrs["date"]
      assert news.text == attrs["text"]
      assert news.title == attrs["title"]
    end

    test "create_news/1 with invalid data returns error changeset" do
      attrs = invalid_news_attrs()
      assert {:error, %Ecto.Changeset{}} = Content.create_news(attrs)
    end

    test "update_news/2 with valid data updates the news" do
      news = news_fixture()
      attrs = update_news_attrs()
      assert {:ok, %News{} = news} = Content.update_news(news, attrs)
      assert news.author == attrs["author"]
      assert news.caption == attrs["caption"]
      assert news.date == attrs["date"]
      assert news.text == attrs["text"]
      assert news.title == attrs["title"]
    end

    test "update_news/2 with invalid data returns error changeset" do
      news = news_fixture()
      attrs = invalid_news_attrs()
      assert {:error, %Ecto.Changeset{}} = Content.update_news(news, attrs)
      assert news == Content.get_news!(news.id)
    end

    test "delete_news/1 deletes the news" do
      news = news_fixture()
      assert {:ok, %News{}} = Content.delete_news(news)
      assert is_nil(Content.get_news!(news.id))
    end

    test "change_news/1 returns a news changeset" do
      news = news_fixture()
      assert %Ecto.Changeset{} = Content.change_news(news)
    end
  end
end
