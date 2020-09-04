defmodule AOFF.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Admin.Association

  @doc """
  Returns the list of associations.

  ## Examples

      iex> list_associations()
      [%Association{}, ...]

  """
  def list_associations do
    Repo.all(Association)
  end

  @doc """
  Gets a single association.

  Raises `Ecto.NoResultsError` if the Association does not exist.

  ## Examples

      iex> get_association!(123)
      %Association{}

      iex> get_association!(456)
      ** (Ecto.NoResultsError)

  """
  def get_association!(id), do: Repo.get!(Association, id)


  @doc """
  Gets a association by name.
  ## Examples

      iex> find_or_create_association("some_name")
      %Association{}


  """
  def find_or_create_association(name) do
    query =
      from a in Association,
      where: a.name==^name,
      limit: 1

    case Repo.one(query) do
      nil ->
        create_association(%{"name" => name})
      %Association{} = association ->
        {:ok, association}
    end
  end

  @doc """
  Creates a association.

  ## Examples

      iex> create_association(%{field: value})
      {:ok, %Association{}}

      iex> create_association(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_association(attrs \\ %{}) do
    %Association{}
    |> Association.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a association.

  ## Examples

      iex> update_association(association, %{field: new_value})
      {:ok, %Association{}}

      iex> update_association(association, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_association(%Association{} = association, attrs) do
    association
    |> Association.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a association.

  ## Examples

      iex> delete_association(association)
      {:ok, %Association{}}

      iex> delete_association(association)
      {:error, %Ecto.Changeset{}}

  """
  def delete_association(%Association{} = association) do
    Repo.delete(association)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking association changes.

  ## Examples

      iex> change_association(association)
      %Ecto.Changeset{data: %Association{}}

  """
  def change_association(%Association{} = association, attrs \\ %{}) do
    Association.changeset(association, attrs)
  end
end
