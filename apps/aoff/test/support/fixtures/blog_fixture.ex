defmodule AOFF.Blogs.BlogFixture do
  alias AOFF.Blogs

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

  def create_blog_attrs(attrs \\ %{}) do
    Enum.into(@create_attrs, attrs)
  end

  def update_blog_attrs(attrs \\ %{}) do
    Enum.into(@update_attrs, attrs)
  end

  def invalid_blog_attrs(attrs \\ %{}) do
    Enum.into(@invalid_attrs, attrs)
  end

  def blog_fixture(attrs \\ %{}) do
    {:ok, blog} =
      attrs
      |> Enum.into(@create_attrs)
      |> Blogs.create_blog()

    blog
  end
end
