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
    query =
      from n in News,
      where: n.locale ==^Gettext.get_locale(),
      order_by: [desc: n.date]
    Repo.all(query)

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
      order_by: [desc: n.date],
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

  alias AOFF.Content.Category
  alias AOFF.Content.Page

  @doc """
  Returns the list of categorys.

  ## Examples

      iex> list_categorys()
      [%Category{}, ...]

  """
  def list_categories() do
    query =
      from b in Category,
        where: b.locale == ^Gettext.get_locale()

    query
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the News does not exist.

  ## Examples

      iex> get_category!(123)
      %Page{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(title) do
    query =
      from b in Category,
        where: b.title == ^title and b.locale == ^Gettext.get_locale(),
        select: b,
        preload: [pages: ^from(p in Page, order_by: p.date)]

    Repo.one(query)
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

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

    %Category{}
    |> Category.changeset(attrs)
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
  def delete_category(%Category{} = news) do
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
  def get_page!(category_title, title) do
    query =
      from p in Page,
        where: p.title == ^title,
        join: b in assoc(p, :category),
        where: b.title == ^category_title and b.locale == ^Gettext.get_locale(),
        limit: 1

    query
    |> Repo.one()
    |> Repo.preload(:category)
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

    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
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
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{source: %Page{}}

  """
  def change_page(%Page{} = post) do
    Page.changeset(post, %{})
  end
end
