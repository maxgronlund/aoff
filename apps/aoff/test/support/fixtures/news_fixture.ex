defmodule AOFF.Content.NewsFixture do
  alias AOFF.Content

  @create_attrs %{
    "author" => "some author",
    "caption" => "some caption",
    "date" => Date.utc_today(),
    "title" => "sometitle",
    "teaser" => "some teaser",
    "text" => "some text"
  }

  @update_attrs %{
    "author" => "some updated author",
    "caption" => "some updated caption",
    "date" => Date.add(Date.utc_today(), 20),
    "title" => "someupdatedtitle",
    "teaser" => "some updated teaser",
    "text" => "some updated text"
  }

  @invalid_attrs %{
    "author" => nil,
    "caption" => nil,
    "date" => nil,
    "title" => nil,
    "teaser" => nil,
    "text" => nil
  }

  def create_news_attrs(attrs \\ %{}) do
    Enum.into(@create_attrs, attrs)
  end

  def update_news_attrs(attrs \\ %{}) do
    Enum.into(@update_attrs, attrs)
  end

  def invalid_news_attrs(attrs \\ %{}) do
    Enum.into(@invalid_attrs, attrs)
  end

  def news_fixture(attrs \\ %{}) do
    {:ok, news} =
      attrs
      |> Enum.into(@create_attrs)
      |> Content.create_news()

    news
  end
end
