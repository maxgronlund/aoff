defmodule AOFF.Content.CategoryFixture do
  alias AOFF.Content

  @create_attrs %{
    "title" => "some title",
    "description" => "some description",
    "identifier" => "some identifier",
    "publish" => true
  }

  @update_attrs %{
    "title" => "some updated title",
    "description" => "some updated description",
    "identifier" => "some updated identifier",
    "publish" => false
  }

  @invalid_attrs %{
    "title" => nil,
    "desctiption" => nil,
    "identifier" => nil
  }

  def create_category_attrs(attrs \\ %{}) do
    Enum.into(@create_attrs, attrs)
  end

  def update_category_attrs(attrs \\ %{}) do
    Enum.into(@update_attrs, attrs)
  end

  def invalid_category_attrs(attrs \\ %{}) do
    Enum.into(@invalid_attrs, attrs)
  end

  def category_fixture(attrs \\ %{}) do
    {:ok, category} = Content.create_category("public", Enum.into(attrs, @create_attrs))

    category
  end
end
