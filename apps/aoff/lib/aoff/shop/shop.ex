defmodule AOFF.Shop do
  @moduledoc """
  The Shop context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Shop.Date

  def secure_dates() do
    query = from d in Date, limit: 1

    if Repo.one(query) == nil do
      Date.build_defaults()
    end
  end

  @doc """
  Returns the list of dates.

  ## Examples

      iex> list_dates()
      [%Date{}, ...]

  """

  def list_dates do
    dates =
      from d in Date,
        order_by: [asc: d.date]

    dates
    |> Repo.all()
  end

  @doc """
  Returns the list of dates.

  ## Examples

      iex> list_dates()
      [%Date{}, ...]

  """
  @dates_pr_page 4

  def list_dates(date, page \\ 0, per_page \\ @dates_pr_page) do
    query =
      from d in Date,
        where: d.last_order_date >= ^date,
        order_by: [asc: d.date],
        limit: ^per_page,
        offset: ^(page * per_page)

    Repo.all(query)
  end

  def list_all_dates(date, page \\ 0, per_page \\ @dates_pr_page) do
    query =
      from d in Date,
        order_by: [asc: d.date],
        limit: ^per_page,
        offset: ^(page * per_page)

    Repo.all(query)
  end

  def date_pages(per_page \\ @dates_pr_page) do
    dates = Repo.one(from d in Date, select: count(d.id))
    Integer.floor_div(dates, per_page)
  end

  def todays_page(dates_pr_page \\ @dates_pr_page) do
    query =
      from d in Date,
        where: d.date < ^AOFF.Time.today(),
        select: count(d.id)

    Integer.floor_div(Repo.one(query), dates_pr_page)

    # query =
    #   from d in Date,
    #     where: d.date <= ^AOFF.Time.today(),
    #     order_by: [asc: d.date],
    #     select: count(d.id)

    # Repo.one(query)
  end

  def products_ordered() do
    today = AOFF.Time.today()

    query =
      from d in Date,
        where: d.date >= ^today,
        order_by: [asc: d.date],
        limit: 1

    date = Repo.one(query)

    case Elixir.Date.compare(today, date.last_order_date) do
      :gt -> true
      _ -> false
    end
  end

  @doc """
  Gets a single date.

  Raises `Ecto.NoResultsError` if the Date does not exist.

  ## Examples

      iex> get_date!(123)
      %Date{}

      iex> get_date!(456)
      ** (Ecto.NoResultsError)

  """
  def get_date!(id), do: Repo.get!(Date, id)

  @doc """

  Gets next opening date.

  Raises `Ecto.NoResultsError` if the Date does not exist.

  ## Examples

      iex> get_date!(123)
      %Date{}

      iex> get_date!(456)
      ** (Ecto.NoResultsError)

  """
  def get_next_date(last_order_date) do
    query =
      from d in Date,
        where: d.last_order_date >= ^last_order_date,
        order_by: [asc: d.date],
        limit: 1

    Repo.one(query)
  end

  @doc """
  Creates a date.

  ## Examples

      iex> create_date(%{field: value})
      {:ok, %Date{}}

      iex> create_date(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_date(attrs \\ %{}) do
    %Date{}
    |> Date.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a date.

  ## Examples

      iex> update_date(date, %{field: new_value})
      {:ok, %Date{}}

      iex> update_date(date, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_date(%Date{} = date, attrs) do
    date
    |> Date.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a date.

  ## Examples

      iex> delete_date(date)
      {:ok, %Date{}}

      iex> delete_date(date)
      {:error, %Ecto.Changeset{}}

  """
  def delete_date(%Date{} = date) do
    Repo.delete(date)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking date changes.

  ## Examples

      iex> change_date(date)
      %Ecto.Changeset{source: %Date{}}

  """
  def change_date(%Date{} = date) do
    Date.changeset(date, %{})
  end

  alias AOFF.Shop.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    query =
      from p in Product,
      order_by: [asc: p.position],
      where: p.deleted == false and p.membership == false

    Repo.all(query)
  end

  @doc """
  Returns the list of products for sale.

  ## Examples

      iex> list_products(:for_sale)
      [%Product{}, ...]

  """
  def list_products(:for_sale) do
    query =
      from p in Product,
        order_by: [asc: p.position],
        where: p.for_sale == true and p.deleted == false and p.membership == false

    Repo.all(query)
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_memberships() do
    query =
      from p in Product,
        order_by: [asc: p.position],
        where: p.deleted == false and p.membership == true

    Repo.all(query)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Gets all product there is a membership

  Return nil is `nil` if notning is found

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """

  def get_products_for_landing_page() do
    query =
      from p in Product,
        where: p.show_on_landing_page == ^true

    query
    |> Repo.all()
  end

  def get_memberships() do
    query =
      from p in Product,
        where: p.membership == true and p.deleted == false

    result = Repo.all(query)

    cond do
      result == [] ->
        {:ok, product} =
          create_product(%{
            "name_da" => "Medlemsskab",
            "name_en" => "Membership",
            "membership"  => true,
            "price" => Money.new(100 * 100, :DKK),
            "description_da" => "Et års medlemskab",
            "description_en" => "One year of membership - "
          })

        [product]

      true ->
        result
    end
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    # Repo.delete(product)
    product
    |> Product.delete_changeset(%{
      "deleted" => true,
      "show_on_landing_page" => false
    })
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias AOFF.Shop.PickUp

  @doc """
    Returns a `%PickUp{}` for use in the shop

  ## Examples

    iex> find_or_create_pickup(valid_params)
    %PickUp{}

    iex> find_or_create_pickup(invalid_params)
    %Ecto.Changeset{source: %PickUp{}}

  """
  def find_or_create_pick_up(%{
        "date_id" => date_id,
        "user_id" => user_id,
        "username" => username,
        "member_nr" => member_nr,
        "order_id" => order_id,
        "email" => email
      }) do
    query =
      from p in PickUp,
        where:
          p.user_id == ^user_id and p.date_id == ^date_id and p.picked_up == false and
            p.order_id == ^order_id,
        limit: 1

    case Repo.one(query) do
      nil ->
        create_pick_up(%{
          "user_id" => user_id,
          "username" => username,
          "member_nr" => member_nr,
          "date_id" => date_id,
          "picked_up" => false,
          "order_id" => order_id,
          "email" => email
        })

      %PickUp{} = pick_up ->
        {:ok, pick_up}
    end
  end

  @doc """
  Returns the list of pick_ups.

  ## Examples

      iex> list_pick_ups()
      [%PickUp{}, ...]

  """
  def list_pick_ups(date_id) do
    query =
      from(
        p in PickUp,
        where: p.date_id == ^date_id,
        order_by: p.username,
        join: oi in assoc(p, :order_items),
        join: o in assoc(oi, :order),
        where: o.state == ^"payment_accepted",
        join: pr in assoc(oi, :product),
        where: pr.membership == ^false,
        distinct: true
      )

    query
    |> Repo.all()
    |> Repo.preload(:user)
    |> Repo.preload(:order)
    |> Repo.preload(order_items: [:product])
  end

  @doc """
  Returns the list of pick_ups.

  ## Examples

      iex> list_upcomming_pick_ups(user_id)
      [%PickUp{}, ...]

  """
  def list_upcomming_pick_ups(user_id, next_date) do
    query =
      from(
        p in PickUp,
        where: p.user_id == ^user_id and p.picked_up == ^false,
        join: oi in assoc(p, :order_items),
        join: o in assoc(oi, :order),
        where: o.state == ^"payment_accepted",
        join: pr in assoc(oi, :product),
        where: pr.membership == ^false,
        join: d in assoc(p, :date),
        where: d.date >= ^next_date,
        distinct: true
      )

    pick_ups =
      query
      |> Repo.all()
      |> Repo.preload(:user)
      |> Repo.preload(:order)
      |> Repo.preload(order_items: [:product])
      |> Repo.preload(:date)

    if Enum.empty?(pick_ups), do: false, else: pick_ups
  end

  @doc """
  Gets a single pick_up.

  Raises `Ecto.NoResultsError` if the PickUp does not exist.

  ## Examples

      iex> get_pick_up!(123)
      %PickUp{}

      iex> get_pick_up!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pick_up!(id) do
    PickUp
    |> Repo.get!(id)
    |> Repo.preload(:user)
    |> Repo.preload(:date)
    |> Repo.preload(:order)
    |> Repo.preload(order_items: [:product])
  end

  def search_pick_up(query, date_id) do
    query =
      if is_numeric(query) do
        from(
          p in PickUp,
          where: p.member_nr == ^query and p.date_id == ^date_id
        )
      else
        from(p in PickUp,
          where:
            ilike(p.username, ^"%#{query}%") or
              (ilike(p.email, ^"%#{query}%") and p.date_id == ^date_id)
        )
      end

    query
    |> Repo.all()
    |> Repo.preload(:user)
    |> Repo.preload(:order)
    |> Repo.preload(order_items: [:product])
  end

  defp is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  @doc """
  Creates a pick_up.

  ## Examples

      iex> create_pick_up(%{field: value})
      {:ok, %PickUp{}}

      iex> create_pick_up(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pick_up(attrs \\ %{}) do
    %PickUp{}
    |> PickUp.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pick_up.

  ## Examples

      iex> update_pick_up(pick_up, %{field: new_value})
      {:ok, %PickUp{}}

      iex> update_pick_up(pick_up, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pick_up(%PickUp{} = pick_up, attrs) do
    pick_up
    |> PickUp.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pick_up.

  ## Examples

      iex> delete_pick_up(pick_up)
      {:ok, %PickUp{}}

      iex> delete_pick_up(pick_up)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pick_up(%PickUp{} = pick_up) do
    Repo.delete(pick_up)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pick_up changes.

  ## Examples

      iex> change_pick_up(pick_up)
      %Ecto.Changeset{source: %PickUp{}}

  """
  def change_pick_up(%PickUp{} = pick_up) do
    PickUp.changeset(pick_up, %{})
  end

  alias AOFF.Users.OrderItem

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def paid_orders_list(date_id) do
    query =
      from o in OrderItem,
        where: o.date_id == ^date_id,
        join: ordr in assoc(o, :order),
        where: ordr.state == ^"payment_accepted",
        join: p in assoc(o, :product),
        where: p.membership == ^false,
        group_by: p.id,
        select: {p, count(o.id)}

    Repo.all(query)
  end
end
