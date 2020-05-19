defmodule AOFF.Content.CategoryFixture do
  alias AOFF.Content

  @create_attrs %{
    "title" => "some title",
    "description" => "some description",
    "identifier" => "some identifier"
  }

  @update_attrs %{
    "title" => "some updated title",
    "description" => "some updated description",
    "identifier" => "some updated identifier"
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
    {:ok, category} =
      attrs
      |> Enum.into(@create_attrs)
      |> Content.create_category()

    category
  end
end
