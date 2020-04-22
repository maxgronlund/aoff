defmodule AOFF.Blogs do
  @moduledoc """
  The Blogs context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Blogs.Blog

  @doc """
  Returns the list of blogs.

  ## Examples

      iex> list_blogs()
      [%Blog{}, ...]

  """
  def list_blogs(locale \\ "da") do
    secure_defaults()

    query =
      from b in Blog,
        where: b.locale == ^locale

    query
    |> Repo.all()
  end

  defp secure_defaults(locale \\ "da") do
    {:ok, manufacturers} = find_or_create_blog("manufacturers", locale)
    {:ok, calendar} = find_or_create_blog("calendar", locale)
    {:ok, about_aoff} = find_or_create_blog("about_aoff", locale)
  end

  alias AOFF.Blogs.BlogPost

  def news(locale \\ "da") do
    find_or_create_blog("news-" <> locale, "News", locale)
  end

  def all_but_news(locale \\ "da") do
    query =
      from b in Blog,
        where: b.locale == ^locale and b.identifier != ^"news"

    query
    |> Repo.all()
    |> Repo.preload(:blog_posts)
  end

  @doc """
  Find or create a blog.

  Creates a new blog if the Blog does not exist.

  ## Examples

      iex> get_blog!("news", "da")
      %Blog{}


  """
  def find_or_create_blog(identifier, title, locale \\ "da") do
    query =
      from b in Blog,
        where: b.identifier == ^identifier and b.locale == ^locale,
        select: b,
        preload: [blog_posts: ^from(p in BlogPost, order_by: [desc: p.date])]

    case Repo.one(query) do
      nil ->
        create_blog(%{
          "title" => identifier <> "-" <> locale,
          "description" => identifier <> "-" <> locale <> " : Description",
          "identifier" => identifier,
          "locale" => locale
        })

      %Blog{} = blog ->
        {:ok, blog}
    end
  end

  def get_blog!(title, locale \\ "da") do
    query =
      from b in Blog,
        where: b.title == ^title and b.locale == ^locale,
        select: b,
        preload: [blog_posts: ^from(p in BlogPost, order_by: p.date)]

    Repo.one(query)
  end

  @doc """
  Creates a blog.

  ## Examples

      iex> create_blog(%{field: value})
      {:ok, %Blog{}}

      iex> create_blog(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blog(attrs \\ %{}, locale \\ "da") do
    attrs =
      attrs
      |> Map.merge(%{
        "locale" => locale,
        "identifier" => attrs["title"]
      })

    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blog.

  ## Examples

      iex> update_blog(blog, %{field: new_value})
      {:ok, %Blog{}}

      iex> update_blog(blog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blog(%Blog{} = blog, attrs) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a blog.

  ## Examples

      iex> delete_blog(blog)
      {:ok, %Blog{}}

      iex> delete_blog(blog)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blog(%Blog{} = blog) do
    Repo.delete(blog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog changes.

  ## Examples

      iex> change_blog(blog)
      %Ecto.Changeset{source: %Blog{}}

  """
  def change_blog(%Blog{} = blog) do
    Blog.changeset(blog, %{})
  end

  alias AOFF.Blogs.BlogPost

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(BlogPost)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(blog_title, title, locale \\ "da") do
    query =
      from p in BlogPost,
        where: p.title == ^title,
        join: b in assoc(p, :blog),
        where: b.title == ^blog_title and b.locale == ^locale,
        limit: 1

    query
    |> Repo.one()
    |> Repo.preload(:blog)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %BlogPost{}
    |> BlogPost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%BlogPost{} = post, attrs) do
    post
    |> BlogPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%BlogPost{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%BlogPost{} = post) do
    BlogPost.changeset(post, %{})
  end
end
