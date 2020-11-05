defmodule AOFF.Admin.Admins do
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
  def get_user!(id, prefix) do
    Repo.get!(User, id, prefix: prefix)
  end

  @doc """
  Get the username for a single User.

  returns `-` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** '-'

  """
  def username(id, prefix) do
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
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.admin_update_changeset(attrs)
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
end
