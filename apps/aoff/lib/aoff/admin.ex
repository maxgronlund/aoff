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
        where: a.name == ^name,
        limit: 1

    case Repo.one(query) do
      nil ->
        create_association(%{"name" => name, prefix: prefix(name)})

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
    attrs = Map.put(attrs, "prefix", prefix(attrs["name"]))
    case %Association{} |> Association.changeset(attrs) |> Repo.insert() do
      {:ok, association} ->
        create_schema(association)
        {:ok, association}

      {:error, changeset} ->
        {:error, changeset}
    end
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
    attrs = Map.put(attrs, "prefix", prefix(attrs["name"]))
    Repo.transaction(fn ->
      from_name = association.name

      case association |> Association.changeset(attrs) |> Repo.update() do
        {:ok, association} ->
          if association.name != from_name do
            update_schema(association, from_name)
          end
          association

        {:error, changeset} ->
          changeset |> Repo.rollback()
      end
    end)
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
    case Repo.delete(association) do
      {:ok, association} ->
        delete_schema(association.name)
        {:ok, association}

      {:error, reason} ->
        {:error, reason}
    end
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

  defp create_schema(association) do
    case Ecto.Adapters.SQL.query(Repo, "CREATE SCHEMA \"#{prefix(association.name)}\"") do
      {:ok, _} -> {:ok, association}
      {:error, reason} -> {:error, reason}
    end
  end

  defp update_schema(association, from_name) do
    if schema_exists?(from_name) do
      Ecto.Adapters.SQL.query(
        Repo,
        "ALTER SCHEMA #{prefix(from_name)} RENAME TO #{prefix(association.name)}"
      )
    else
      create_schema(association)
    end
  end

  defp delete_schema(name) do
    Ecto.Adapters.SQL.query(Repo, "DROP SCHEMA \"#{prefix(name)}\" CASCADE")
  end

  def prefix(name) do
    prefix =
      name
      |> String.downcase()
      |> String.replace(" ", "_", global: true)

    "prefix_#{prefix}"
  end

  defp schema_exists?(name) do
    name = prefix(name)

    case Ecto.Adapters.SQL.query(
           Repo,
           "SELECT TRUE FROM  information_schema.schemata WHERE schema_name = '#{name}';"
         ) do
      {:ok, %Postgrex.Result{columns: ["bool"], rows: []}} -> false
      {:ok, %Postgrex.Result{columns: ["bool"], rows: [[true]]}} -> true
    end
  end

  def get_prefix_by_host(host) do

    case Repo.get_by(Association, host: host) do
      nil -> "public"
      association ->
        association.prefix
    end
  end
end
