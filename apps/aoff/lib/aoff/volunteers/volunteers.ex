defmodule AOFF.Volunteers do
  @moduledoc """
  The Admin Users context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(prefix) do
    query = from(u in User, order_by: [asc: u.member_nr])
    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
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
  Get the name of a shop assistant.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      "username"

      iex> get_user!(456)
      "-"

  """
  def username(prefix, id) do
    cond do
      id == nil ->
        "-"

      user = Repo.get(User, id, prefix: prefix) ->
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

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(prefix, attrs \\ %{}) do
    attrs =
      attrs
      |> set_unsubsribe_to_news_token()

    %User{expiration_date: Date.add(AOFF.Time.today(), -1)}
    |> User.volunteer_changeset(prefix, attrs)
    |> Repo.insert(prefix: prefix)
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
    attrs = set_unsubsribe_to_news_token(attrs)

    user
    |> User.volunteer_update_changeset(attrs)
    |> Repo.update()
  end

  defp set_unsubsribe_to_news_token(attrs) do
    if attrs["subscribe_to_news"] do
      Map.put(attrs, "unsubscribe_to_news_token", Ecto.UUID.generate())
    else
      Map.put(attrs, "unsubscribe_to_news_token", "")
    end
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

  alias AOFF.Volunteer.Newsletter

  @doc """
  Returns the list of newsletters.

  ## Examples

      iex> list_newsletters()
      [%Newsletter{}, ...]

  """
  def list_newsletters(prefix) do
    Repo.all(Newsletter, prefix: prefix)
  end

  @doc """
  Gets a single newsletter.

  Raises `Ecto.NoResultsError` if the News letter does not exist.

  ## Examples

      iex> get_newsletter!(123)
      %Newsletter{}

      iex> get_newsletter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_newsletter!(prefix, id), do: Repo.get!(Newsletter, id, prefix: prefix)

  @doc """
  Creates a newsletter.

  ## Examples

      iex> create_newsletter(%{field: value})
      {:ok, %Newsletter{}}

      iex> create_newsletter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_newsletter(prefix, attrs \\ %{}) do
    %Newsletter{}
    |> Newsletter.changeset(attrs)
    |> Repo.insert(prefix: prefix)
  end

  @doc """
  Updates a newsletter.

  ## Examples

      iex> update_newsletter(newsletter, %{field: new_value})
      {:ok, %Newsletter{}}

      iex> update_newsletter(newsletter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_newsletter(%Newsletter{} = newsletter, attrs) do
    newsletter
    |> Newsletter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a newsletter.

  ## Examples

      iex> delete_newsletter(newsletter)
      {:ok, %Newsletter{}}

      iex> delete_newsletter(newsletter)
      {:error, %Ecto.Changeset{}}

  """
  def newsletter_send(%Newsletter{} = newsletter) do
    newsletter
    |> Newsletter.send_changeset(%{"send" => true})
    |> Repo.update()
  end

  @doc """
  Deletes a newsletter.

  ## Examples

      iex> delete_newsletter(newsletter)
      {:ok, %Newsletter{}}

      iex> delete_newsletter(newsletter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_newsletter(%Newsletter{} = newsletter) do
    Repo.delete(newsletter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking newsletter changes.

  ## Examples

      iex> change_newsletter(newsletter)
      %Ecto.Changeset{data: %Newsletter{}}

  """
  def change_newsletter(%Newsletter{} = newsletter, attrs \\ %{}) do
    Newsletter.changeset(newsletter, attrs)
  end
end
