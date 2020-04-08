defmodule AOFF.Blogs.BlogPostFixture do
  alias AOFF.Blogs

  @create_attrs %{
    "author" => "some author",
    "caption" => "some caption",
    "image" => "some image url",
    "date" => Date.utc_today(),
    "title" => "some title",
    "text" => "some text"
  }

  @update_attrs %{
    "author" => "some updated author",
    "caption" => "some updated caption",
    "image" => "some updated image url",
    "date" => Date.add(Date.utc_today(), 20),
    "title" => "some updated title",
    "text" => "some updated text"
  }

  @invalid_attrs %{
    "author" => nil,
    "caption" => nil,
    "image" => nil,
    "date" => nil,
    "title" => nil,
    "text" => nil
  }

  def create_post_attrs(attrs \\ %{}) do
    Enum.into(@create_attrs, attrs)
  end

  def update_post_attrs(attrs \\ %{}) do
    Enum.into(@update_attrs, attrs)
  end

  def invalid_post_attrs(attrs \\ %{}) do
    Enum.into(@invalid_attrs, attrs)
  end

  def post_fixture(blog_id, attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put("blog_id", blog_id)
      |> Blogs.create_post()

    post
  end
end
