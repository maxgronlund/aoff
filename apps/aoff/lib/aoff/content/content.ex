defmodule AOFF.Content do
  @moduledoc """
  The Admin Users context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Content.News

  @doc """
  Returns the list of news.

  ## Examples

      iex> list_news()
      [%News{}, ...]

  """
  def list_news do
    Repo.all(News)
  end

  @doc """
  Gets the latest news.

  Return [] if no News exist.

  ## Examples

      iex> latest_news()
      [%News{}]

      iex> latest_news()
      []

  """
  def latest_news() do
    query =
      from n in News,
      where: n.locale ==^Gettext.get_locale(),
      order_by: [asc: n.date],
      limit: 3
    Repo.all(query)
  end

  @doc """
  Gets a single news.

  Raises `Ecto.NoResultsError` if the News does not exist.

  ## Examples

      iex> get_news!(123)
      %News{}

      iex> get_news!(456)
      ** (Ecto.NoResultsError)

  """
  def get_news!(id), do: Repo.get!(News, id)

  @doc """
  Creates a news.

  ## Examples

      iex> create_news(%{field: value})
      {:ok, %News{}}

      iex> create_news(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_news(attrs \\ %{}) do
    %News{}
    |> News.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a news.

  ## Examples

      iex> update_news(news, %{field: new_value})
      {:ok, %News{}}

      iex> update_news(news, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_news(%News{} = news, attrs) do
    news
    |> News.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a news.

  ## Examples

      iex> delete_news(news)
      {:ok, %News{}}

      iex> delete_news(news)
      {:error, %Ecto.Changeset{}}

  """
  def delete_news(%News{} = news) do
    Repo.delete(news)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking news changes.

  ## Examples

      iex> change_news(news)
      %Ecto.Changeset{source: %News{}}

  """
  def change_news(%News{} = news) do
    News.changeset(news, %{})
  end

  alias AOFF.Blogs.Blog
  alias AOFF.Blogs.BlogPost

  @doc """
  Returns the list of blogs.

  ## Examples

      iex> list_blogs()
      [%Blog{}, ...]

  """
  def list_categories() do
    query =
      from b in Blog,
        where: b.locale == ^Gettext.get_locale()

    query
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the News does not exist.

  ## Examples

      iex> get_category!(123)
      %BlogPost{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(title) do
    query =
      from b in Blog,
        where: b.title == ^title and b.locale == ^Gettext.get_locale(),
        select: b,
        preload: [blog_posts: ^from(p in BlogPost, order_by: p.date)]

    Repo.one(query)
  end

  @doc """
  Updates a blog.

  ## Examples

      iex> update_blog(blog, %{field: new_value})
      {:ok, %Blog{}}

      iex> update_blog(blog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Blog{} = blog, attrs) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog changes.

  ## Examples

      iex> change_blog(blog)
      %Ecto.Changeset{source: %Blog{}}

  """
  def change_category(%Blog{} = blog) do
    Blog.changeset(blog, %{})
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Blog{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    attrs =
      attrs
      |> Map.merge(%{
        "locale" => Gettext.get_locale(),
        "identifier" => attrs["title"]
      })

    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %News{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Blog{} = news) do
    Repo.delete(news)
  end

  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Post{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(blog_title, title) do
    query =
      from p in BlogPost,
        where: p.title == ^title,
        join: b in assoc(p, :blog),
        where: b.title == ^blog_title and b.locale == ^Gettext.get_locale(),
        limit: 1

    query
    |> Repo.one()
    |> Repo.preload(:blog)
  end

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Post{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page(attrs \\ %{}) do
    attrs = Map.put(attrs, "locale", Gettext.get_locale())

    %BlogPost{}
    |> BlogPost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %BlogPost{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%BlogPost{} = page, attrs) do
    page
    |> BlogPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Post{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%BlogPost{} = page) do
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{source: %BlogPost{}}

  """
  def change_page(%BlogPost{} = post) do
    BlogPost.changeset(post, %{})
  end
end
