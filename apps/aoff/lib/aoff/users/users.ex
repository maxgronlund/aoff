defmodule AOFF.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Users.User

  @users_pr_page 10

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """

  def list_users(page \\ 0, per_page \\ @users_pr_page) do
    query =
      from u in User,
        order_by: [asc: u.member_nr],
        limit: ^per_page,
        offset: ^(page * per_page)

    Repo.all(query)
  end

  # def list_users() do
  #   list_users(0, @users_pr_page)
  # end

  def user_pages(per_page \\ @users_pr_page) do
    users = Repo.one(from u in User, select: count(u.id))
    Integer.floor_div(users, per_page)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_shop_assistans() do
    query = from(u in User, order_by: [asc: u.username], where: u.shop_assistant == ^true)
    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Gets a single user.

  Return nil if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      nil

  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Gets a username.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def username(id) do
    cond do
      id == nil ->
        "-"

      user = Repo.get(User, id) ->
        user.username

      true ->
        "-"
    end
  end

  @doc """
  Register a user.

  ## Examples
      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Get a user by email

  ## Examples

      iex> get_user_by_email("good@example.com")
      {:ok, %User{}}

      iex> get_user_by_email("bad@example.com")
      TODO: what are we getting here?
  """
  def get_user_by_email(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.one()
  end

  @doc """
  Get a user by member number

  ## Examples

      get_user_by_member_nr(12)
      [%User]

      iex> get_user_by_member_nr(asd)
      []
  """
  def get_users_by_email(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.all()
  end

  @doc """
  Get a user by member number

  ## Examples

      get_user_by_member_nr(12)
      [%User]

      iex> get_user_by_member_nr(asd)
      []
  """
  def get_users_by_member_nr(member_nr) do
    from(u in User, where: u.member_nr == ^member_nr)
    |> Repo.all()
  end

  @doc """
  Get a user by member username

  ## Examples

      get_user_by_member_username("John")
      [%User]

      iex> get_user_by_username("Alice")
      []
  """
  def get_users_by_username(username) do
    from(u in User, where: u.username == ^username)
    |> Repo.all()
  end

  def search_users(query) do
    if is_numeric(query) do
      get_users_by_member_nr(String.to_integer(query))
    else
      from(u in User, where: like(u.username, ^query) or u.email == ^query)
      |> Repo.all()
    end
  end

  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  @doc """
  Authenticate a user by email and password

  ##Examples
      iex> aughenticate_by_email_and_pass("ok@example.com", "ok_password")
      {:ok, user}

      iex> aughenticate_by_email_and_pass("ok@example.com", "wrong_password")
      {:error, :unauthorized}

      iex> aughenticate_by_email_and_pass("unknown@example.com", "dosent-matter")
      {:error, :not_fount}
  """
  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by_email(email)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end

  def last_member_nr() do
    query = from(u in User, order_by: [desc: u.member_nr], select: u.member_nr, limit: 1)
    Repo.one(query)
  end

  alias AOFF.Users.Order

  def current_order(user_id) do
    find_or_create_order(user_id)
  end

  def find_or_create_order(user_id) do
    query =
      from o in Order,
        where: o.user_id == ^user_id and o.state == ^"open",
        limit: 1

    case Repo.one(query) do
      nil ->
        create_order(
          %{
            "user_id" => user_id,
            "order_nr"=> create_order_nr()
          }
        )
      %Order{} = order -> {:ok, order}
    end
  end



  def last_order_nr() do
    query =
      from o in Order,
        order_by: [desc: o.order_nr],
        select: o.order_nr,
        limit: 1

    Repo.one(query) || 99
  end

  def create_order_nr() do
    last_order_nr() + 1
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(user_id) do
    query =
      from o in Order,
        where: o.user_id == ^user_id,
        order_by: [asc: o.order_nr]

    Repo.all(query)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id) do
    Order
    |> Repo.get!(id)
    |> Repo.preload(:user)
    |> Repo.preload(order_items: [:product, :date])
  end

  # alias AOFF.Users.OrderItem
  # alias AOFF.Shop.Product

  # def order_total(order_id) do
  #   q =
  #     from o in Order,
  #     where: o.id==^order_id,
  #     left_join: oi in assoc(o, :order_items),
  #     select: oi.product_id

  #   ids = Repo.all(q)

  #   q = from p in Product,
  #     where: p.id in ^ids,
  #     select: type(sum(p.price), p.price)

  #   Repo.one(q)
  # end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    result =
      order
      |> Order.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  # def delete_order(%Order{} = order) do
  #   Repo.delete(order)
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end

  alias AOFF.Users.OrderItem

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, ...]

  """
  # def list_order_items do
  #   Repo.all(OrderItem)
  # end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id) do
    OrderItem
    |> Repo.get!(id)
    |> Repo.preload(order: [:user])
  end

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}) do

    {:ok, %Order{} = order} = current_order(attrs["user_id"])
    {price, _} = attrs["price"] |> Float.parse()

    price = Money.new(trunc(price), :DKK)

    attrs =
      attrs
      |> Map.merge(
        %{
          "price" => price
        }
      )

    result = %OrderItem{}
      |> OrderItem.changeset(attrs)
      |> Repo.insert()

    with {:ok, order_item} <- result do
      order = get_order!(order_item.order_id)
      total = order_total(order.id)
      update_order(order, %{"total" => total})
    end


    result
  end

  defp order_total(order_id) do

    q =
      from i in OrderItem,
      where: i.order_id==^order_id,
      select: type(sum(i.price), i.price)

    Repo.one(q)

  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def update_order_item(%OrderItem{} = order_item, attrs) do
  #   order_item
  #   |> OrderItem.changeset(attrs)
  #   |> Repo.update()
  # end

  @doc """
  Deletes a order_item.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    result = Repo.delete(order_item)
    with {:ok, order_item} <- result do
      order = get_order!(order_item.order_id)
      total = order_total(order.id)
      update_order(order, %{"total" => total})
    end
    result
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_order_item(order_item)
      %Ecto.Changeset{source: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item) do
    OrderItem.changeset(order_item, %{})
  end
end
