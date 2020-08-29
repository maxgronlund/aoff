defmodule AOFF.Content do
  @moduledoc """
  The Admin Users context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Content.Category
  alias AOFF.Content.Page

  @doc """
  Returns the list of published categorys.

  ## Examples

      iex> list_categorys()
      [%Category{}, ...]

  """
  def list_categories() do
    query =
      from c in Category,
        where: c.locale == ^Gettext.get_locale() and (c.publish == true),
        order_by: [desc: c.position]

    query
    |> Repo.all()
  end

  @doc """
  Returns the list of all categorys.

  ## Examples

      iex> list_categorys()
      [%Category{}, ...]

  """
  def list_categories(:all) do
    query =
      from c in Category,
        where: c.locale == ^Gettext.get_locale(),
        order_by: [desc: c.position]

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
      from c in Category,
        where: c.title == ^title and c.locale == ^Gettext.get_locale(),
        select: c,
        preload: [
          pages: ^from(p in Page, where: p.publish == ^true, order_by: [desc: p.position])
        ]

    Repo.one(query)
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
  def get_category!(:all, title) do
    query =
      from c in Category,
        where: c.title == ^title and c.locale == ^Gettext.get_locale(),
        select: c,
        preload: [pages: ^from(p in Page, order_by: [desc: p.position])]

    Repo.one(query)
  end

  @doc """
  Find or create a single category.

  ## Examples
      iex> get_category!("birds")
      {:ok, %Category{}}

  """
  def find_or_create_category(category) do
    query =
      from c in Category,
        where: c.identifier == ^category and c.locale == ^Gettext.get_locale(),
        select: c,
        preload: [pages: ^from(p in Page, order_by: [desc: p.date])]

    case Repo.one(query) do
      nil ->
        create_category(%{
          "title" => category,
          "description" => category,
          "identifier" => category,
          "locale" => Gettext.get_locale()
        })

      %Category{} = category ->
        {:ok, category}
    end
  end

  def featured_pages() do
    query =
      from p in Page,
        where: p.show_on_landing_page == ^true and p.locale == ^Gettext.get_locale(),
        order_by: [desc: p.date],
        limit: 3

    query |> Repo.all() |> Repo.preload(:category)
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
      ** nil

  """
  def get_page!(category_title, title) do
    # TODO: rename to get_page
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

  def get_page(id) do
    Repo.one(from p in Page, where: p.id == ^id)
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
  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end
end
