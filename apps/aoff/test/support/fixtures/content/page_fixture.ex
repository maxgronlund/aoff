defmodule AOFF.Content.PageFixture do
  alias AOFF.Content

  @create_attrs %{
    "author" => "some author",
    "caption" => "some caption",
    "image" => "some image url",
    "date" => Date.utc_today(),
    "title" => "sometitle",
    "teaser" => "some teaser",
    "tag" => "some tag",
    "text" => "some text",
    "position" => 1,
    "signup_to_event" => false
  }

  @update_attrs %{
    "author" => "some updated author",
    "caption" => "some updated caption",
    "image" => "some updated image url",
    "date" => Date.add(Date.utc_today(), 20),
    "title" => "someupdatedtitle",
    "teaser" => "some updated teaser",
    "tag" => "some updated tag",
    "text" => "some updated text",
    "position" => 2,
    "signup_to_event" => true
  }

  @invalid_attrs %{
    "author" => nil,
    "caption" => nil,
    "image" => nil,
    "date" => nil,
    "title" => nil,
    "teaser" => nil,
    "tag" => nil,
    "text" => nil,
    "position" => nil
  }

  def create_page_attrs(attrs \\ %{}) do
    Enum.into(@create_attrs, attrs)
  end

  def update_page_attrs(attrs \\ %{}) do
    Enum.into(@update_attrs, attrs)
  end

  def invalid_page_attrs(attrs \\ %{}) do
    Enum.into(@invalid_attrs, attrs)
  end

  def page_fixture(category_id, attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put("category_id", category_id)
      |> Content.create_page("public")

    page
  end
end
