defmodule AOFF.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Users.User

  @users_pr_page 40

  @doc """
  Returns the list of users subscribing to the newsletter .

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(prefix, :newsletter) do
    query =
      from u in User,
        where: u.subscribe_to_news == ^true

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(prefix, page \\ 0, per_page \\ @users_pr_page) do
    query =
      from u in User,
        order_by: [asc: u.username],
        limit: ^per_page,
        offset: ^(page * per_page)

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns a stream of users with username and email.

  ## Examples

      iex> stream_users()
      [Stream<["name", "email"]>, ...]

  """

  def stream_users(prefix, callback) do
    query =
      from u in User,
        order_by: [asc: u.username],
        select: [u.username, u.email]

    stream = Repo.stream(query, prefix: prefix)

    Repo.transaction(fn ->
      callback.(stream)
    end)
  end

  @doc """
  Returns the count of all users

  ## Examples
    iex> member_count(:all)
    1234
  """
  def member_count(prefix, :all) do
    query =
      from u in User,
        select: count(u.id)

    Repo.one(query, prefix: prefix)
  end

  @doc """
  Returns the count of all users with a valid membership

  ## Examples
    iex> member_count(:valid)
    1234
  """
  def member_count(prefix, :valid) do
    query =
      from u in User,
        where: u.expiration_date >= ^AOFF.Time.today(),
        select: count(u.id)

    Repo.one(query, prefix: prefix)
  end

  @doc """
  Returns the count of all users who subscribe to the newsletter

  ## Examples
    iex> member_count(:all)
    1234
  """
  def member_count(prefix, :subscribers) do
    query =
      from u in User,
        where: u.subscribe_to_news >= ^true,
        select: count(u.id)

    Repo.one(query, prefix: prefix)
  end

  def user_pages(prefix, per_page \\ @users_pr_page) do
    query = from u in User, select: count(u.id)
    users = Repo.one(query, prefix: prefix)
    Integer.floor_div(users, per_page)
  end

  def host_dates(date, user_id) do
    dates =
      from d in AOFF.Shop.Date,
        order_by: [asc: d.date],
        where: d.date >= ^date,
        where:
          d.shop_assistant_a == ^user_id or d.shop_assistant_b == ^user_id or
            d.shop_assistant_c == ^user_id or d.shop_assistant_d == ^user_id

    host_dates =
      dates
      |> Repo.all()

    if Enum.empty?(host_dates), do: false, else: host_dates
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_volunteers()
      [%User{}, ...]

  """
  def list_volunteers(prefix) do
    query = from(u in User, order_by: [asc: u.username], where: u.volunteer == ^true)
    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_shop_assistans()
      [%User{}, ...]

  """
  def list_shop_assistans(prefix) do
    query = from(u in User, order_by: [asc: u.username], where: u.shop_assistant == ^true)
    Repo.all(query, prefix: prefix)
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
  def get_user!(prefix, id) do
    Repo.get!(User, id, prefix: prefix)
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
  def get_user(prefix, id) do
    Repo.get(User, id, prefix: prefix)
  end

  @doc """
  Gets a single user by password_reset_token.

  Return nil if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      nil
  """
  def get_user_by_reset_password_token(prefix, token) do
    cond do
      token == "" -> nil
      token == nil -> nil
      true -> Repo.get_by(User, %{password_reset_token: token}, prefix: prefix)
    end
  end

  defp set_subsribe_to_news_token(attrs) do
    case attrs["subscribe_to_news"] do
      "true" ->
        Map.put(attrs, "unsubscribe_to_news_token", Ecto.UUID.generate())

      _ ->
        Map.put(attrs, "unsubscribe_to_news_token", "")
    end
  end

  @doc """
  Gets a single user by password_reset_token.

  Return nil if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      nil
  """
  def get_user_by_unsubscribe_to_news_token(prefix, token) do
    cond do
      token == "" -> nil
      token == nil -> nil
      true -> Repo.get_by(User, %{unsubscribe_to_news_token: token}, prefix: prefix)
    end
  end

  def set_unsubscribe_to_news_token(user) do
    user
    |> User.unsubscribe_to_news_change(%{
      unsubscribe_to_news_token: Ecto.UUID.generate()
    })
    |> Repo.update()
  end

  def unsubscribe_to_news(user) do
    user
    |> User.unsubscribe_to_news_change(%{
      subscribe_to_news: false,
      unsubscribe_to_news_token: nil
    })
    |> Repo.update()
  end

  def subscribe_to_news(user) do
    user
    |> User.unsubscribe_to_news_change(%{
      subscribe_to_news: true,
      unsubscribe_to_news_token: Ecto.UUID.generate()
    })
    |> Repo.update()
  end

  @doc """
  Register a user.

  ## Examples
      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(prefix, attrs \\ %{}) do
    attrs = set_subsribe_to_news_token(attrs)

    %User{expiration_date: Date.add(AOFF.Time.today(), -1)}
    |> User.registration_changeset(attrs)
    |> Repo.insert(prefix: prefix)
  end

  @doc """
  Confirm a user

  ### Example
      iex confirm_user(user)
      {:ok, %User{}}

  """
  def confirm_user(user) do
    user
    |> User.confirmation_changeset(%{confirmed_at: AOFF.Time.today()})
    |> Repo.update()
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
    attrs = set_subsribe_to_news_token(attrs)

    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def set_password_reset_token(user, attrs) do
    user
    |> User.password_reset_token_changeset(attrs)
    |> Repo.update()
  end

  def update_password!(%User{} = user, attrs) do
    attrs = Map.put(attrs, "password_reset_token", "")

    user
    |> User.update_password_changeset(attrs)
    |> Repo.update()
  end

  def update_membership(%User{} = user, attrs) do
    user
    |> User.update_membership_changeset(attrs)
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
      nil
  """
  def get_user_by_email(prefix, email) do
    from(u in User, where: u.email == ^email)
    |> Repo.one(prefix: prefix)
  end

  @doc """
  Get a user by member number

  ## Examples

      get_user_by_member_nr(12, prefix)
      [%User]

      iex> get_user_by_member_nr(asd, prefix)
      []
  """
  def get_users_by_email(prefix, email) do
    from(u in User, where: u.email == ^email)
    |> Repo.all(prefix: prefix)
  end

  @doc """
  Get users by member number

  ## Examples

      get_user_by_member_nr(12)
      [%User]

      iex> get_user_by_member_nr(asd)
      []
  """
  def get_users_by_member_nr(prefix, member_nr) do
    from(u in User, where: u.member_nr == ^member_nr)
    |> Repo.all(prefix: prefix)
  end

  @doc """
  Get one user by member number

  ## Examples

      get_user_by_member_nr(12)
      [%User]

      iex> get_user_by_member_nr(asd)
      []
  """
  def get_user_by_member_nr(prefix, member_nr) do
    from(u in User, where: u.member_nr == ^member_nr, limit: 1)
    |> Repo.one(prefix: prefix)
  end

  @doc """
  Get a user by member username

  ## Examples

      get_user_by_member_username("John")
      [%User]

      iex> get_user_by_username("Alice")
      []
  """
  def get_users_by_username(prefix, username) do
    from(u in User, where: u.username == ^username)
    |> Repo.all(prefix: prefix)
  end

  def search_users(prefix, query) do
    if is_numeric(query) do
      get_users_by_member_nr(prefix, String.to_integer(query))
    else
      from(u in User, where: ilike(u.username, ^"%#{query}%") or ilike(u.email, ^"%#{query}%"))
      |> Repo.all(prefix: prefix)
    end
  end

  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      _ -> false
    end
  end

  defp hash_mod_of_user(user) do
    cond do
      is_nil(user) -> {:error, :no_user}
      String.starts_with?(user.password_hash, "$pbkdf2") -> Pbkdf2
      String.starts_with?(user.password_hash, "$drupal7") -> Drupal7PasswordHash
      true -> {:error, :bad_hash}
    end
  end

  @doc """
  Authenticate a user by email and password

  ##Examples
      iex> aughenticate_by_email_and_pass("ok@example.com", "ok_password")
      {:ok, user}

      iex> aughenticate_by_email_and_pass("ok@example.com", "wrong_password")
      {:error, :unauthorized}

      iex> authenticate_by_email_and_pass("unknown@example.com", "dosent-matter")
      {:error, :not_found}
  """
  def authenticate_by_email_and_pass(prefix, email, given_pass) do
    user = get_user_by_email(prefix, email)
    hash_mod_of_user = hash_mod_of_user(user)

    cond do
      {:error, :no_user} == hash_mod_of_user(user) ->
        Bcrypt.no_user_verify()
        {:error, :not_found}

      {:error, :bad_hash} == hash_mod_of_user(user) ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}

      user && hash_mod_of_user.verify_pass(given_pass, user.password_hash) ->
        # TODO: expires this
        if hash_mod_of_user(user) == Drupal7PasswordHash do
          User.update_password_changeset(user, %{"password" => given_pass})
        end

        {:ok, user}

      true ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}
    end
  end

  def last_member_nr() do
    query = from(u in User, order_by: [desc: u.member_nr], select: u.member_nr, limit: 1)
    Repo.one(query)
  end

  alias AOFF.Users.Order

  def current_order(prefix, user_id) do
    query =
      from o in Order,
        where: o.user_id == ^user_id and o.state == ^"open",
        limit: 1

    case Repo.one(query, prefix: prefix)
         |> Repo.preload(order_items: [:product, :date])
         |> Repo.preload(:user) do
      %Order{} = order ->
        order

      _ ->
        {:ok, _order} = create_order(prefix, %{"user_id" => user_id})
        current_order(prefix, user_id)
    end
  end

  def search_orders(prefix, query) do
    query =
      if is_numeric(query) do
        from o in Order,
          join: u in assoc(o, :user),
          where: o.order_nr == ^query or u.member_nr == ^query
      else
        from o in Order,
          join: u in assoc(o, :user),
          where:
            (o.state != ^"cancled" and
               ilike(u.username, ^"%#{query}%") and
               o.state != "open") or
              (o.state != ^"cancled" and
                 ilike(u.email, ^"%#{query}%") and
                 o.state != "open")
      end

    query
    |> Repo.all(prefix: prefix)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """

  def list_orders(prefix, user_id) do
    query =
      from o in Order,
        where:
          o.user_id == ^user_id and
            o.state == ^"payment_accepted" and
            o.state != ^"cancled",
        order_by: [desc: o.order_nr]

    Repo.all(query, prefix: prefix)
  end

  @orders_pr_page 32

  def list_orders(prefix, :all, page \\ 0, per_page \\ @orders_pr_page) do
    query =
      from o in Order,
        limit: ^per_page,
        offset: ^(page * per_page),
        order_by: [desc: o.order_nr]

    query
    |> Repo.all(prefix: prefix)
    |> Repo.preload(:user)
  end

  def order_pages_count(prefix, per_page \\ @orders_pr_page) do
    query =
      from o in Order,
        where: o.state != ^"open",
        select: count(o.id)

    orders = Repo.one(query, prefix: prefix)
    Integer.floor_div(orders, per_page)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      nil

  """
  def get_order(prefix, id) do
    Order |> Repo.get(id, prefix: prefix)
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
  def get_order!(prefix, id) do
    Order
    |> Repo.get!(id, prefix: prefix)
    |> Repo.preload(:user)
    |> Repo.preload(order_items: [:product, :date])
  rescue
    Ecto.Query.CastError -> nil
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
  def get_order_by_token!(prefix, token) do
    Order
    |> Repo.get_by(%{token: token}, prefix: prefix)
    |> Repo.preload(:user)
    |> Repo.preload(order_items: [:product, :date])
  rescue
    Ecto.Query.CastError -> nil
  end

  def delete_order(%Order{} = order) do
    if order.state == "cancled" do
      {:ok, order}
    else
      order
      |> Order.changeset(%{
        "state" => "cancled",
        "on_deleted_state" => order.state,
        "payment_date" => Date.utc_today()
      })
      |> Repo.update()
    end
  end

  alias AOFF.Shop.Product

  def extend_memberships(order) do
    for _membership <- memberships_in_order(order.id) do
      user = order.user
      today = Date.utc_today()

      expiration_date =
        if user.expiration_date < today do
          Date.add(today, 365)
        else
          Date.add(user.expiration_date, 365)
        end

      User.update_membership_changeset(
        user,
        %{"expiration_date" => expiration_date}
      )
      |> Repo.update()
    end
  end

  defp memberships_in_order(order_id) do
    query =
      from p in Product,
        where: p.membership == ^true,
        join: oi in assoc(p, :order_items),
        where: oi.order_id == ^order_id

    Repo.all(query)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(prefix, attrs \\ %{}) do
    %Order{}
    |> Order.create_changeset(attrs)
    |> Repo.insert(prefix: prefix)
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
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

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

  def order_items_count(prefix, user_id) do
    query =
      from o in OrderItem,
        join: ordr in assoc(o, :order),
        where: ordr.state == ^"open" and ordr.user_id == ^user_id,
        select: count(o.id)

    Repo.one(query, prefix: prefix)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item(123)
      %OrderItem{}

      iex> get_order_item(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item(prefix, id) do
    OrderItem
    |> Repo.get!(id, prefix: prefix)
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
  def create_order_item(prefix, attrs \\ %{}) do
    result =
      %OrderItem{}
      |> OrderItem.changeset(attrs)
      |> Repo.insert(prefix: prefix)

    with {:ok, order_item} <- result do
      order = get_order!(prefix, order_item.order_id)
      total = order_total(prefix, order.id)
      update_order(order, %{"total" => total})
    end

    result
  end

  alias AOFF.Shop

  def add_order_item_to_basket(prefix, pick_up_params, order_item_params) do
    result =
      Repo.transaction(fn ->
        {:ok, pick_up} = Shop.find_or_create_pick_up(prefix, pick_up_params)

        order_item_params
        |> Map.merge(%{"pick_up_id" => pick_up.id})
        |> create_order_item(prefix)
      end)

    case result do
      {:ok, result} -> result
      {:error, error} -> error
    end
  end

  defp order_total(prefix, order_id) do
    q =
      from i in OrderItem,
        where: i.order_id == ^order_id,
        select: type(sum(i.price), i.price)

    Repo.one(q, prefix: prefix)
  end

  @doc """
  Deletes a order_item.

  ## Examples

      iex> delete_order_item(order_item, prefix)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item, prefix)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(prefix, %OrderItem{} = order_item) do
    result = Repo.delete(order_item)

    with {:ok, order_item} <- result do
      order = get_order!(prefix, order_item.order_id)
      total = order_total(prefix, order.id)
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

  def payment_accepted(%Order{} = order, paymenttype \\ "1", card_nr \\ "", order_id \\ "") do
    Order.changeset(order, %{
      "state" => "payment_accepted",
      "order_nr" => last_order_nr() + 1,
      "payment_date" => AOFF.Time.today(),
      "paymenttype" => paymenttype,
      "card_nr" => card_nr,
      "order_id" => order_id
    })
    |> Repo.update()
  end

  # def payment_declined(%Order{} = order) do
  #   unless order.state == "payment_accepted" do
  #     order
  #     |> Order.changeset(%{
  #       "state" => "payment_declined",
  #       "payment_date" => AOFF.Time.today()
  #     })
  #     |> Repo.update()
  #   end
  # end

  @doc """
  Return the last order number

  ## Examples
    iex> last_order_nr()
    10004
  """
  def last_order_nr() do
    query =
      from o in Order,
        where: not is_nil(o.order_nr),
        order_by: [desc: o.order_nr],
        select: o.order_nr,
        limit: 1

    Repo.one(query) || 10001
  end

  def set_bounce_to_url(user, url) do
    User.bounce_to_changeset(user, %{"bounce_to_url" => url})
    |> Repo.update()
  end

  def get_bounce_to_url(user) do
    User.bounce_to_changeset(user, %{"bounce_to_url" => ""})
    |> Repo.update()

    user.bounce_to_url
  end
end
