defmodule AOFF.Events do
  @moduledoc """
  The Event context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Users.User
  alias AOFF.Content.Page
  alias AOFF.Events.Participant



  @doc """
  Returns a list of all participants for the given page.

  ## Examples

      iex> list_participants(:all, page_id)
      [%Participant{}, ...]

  """
  def list_participants(:all, page_id) do
    query =
      from p in Participant,
        where: p.page_id == ^page_id

    query
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Returns one participant.

  ## Examples

      iex> get_participant(id)
      %Participant{}

  """
  def get_participant(id) do
    Participant
    |> Repo.get(id)
    |> Repo.preload(:page)
  end

  def get_participant(page_id, user_id) do
    query =
      from p in Participant,
      where: p.user_id==^user_id and p.page_id==^page_id,
      limit: 1
    query
    |> Repo.one()
  end

  def create_participant(attrs \\ %{}) do
    %Participant{} |> Participant.changeset(attrs) |> Repo.insert()
  end

  @doc """
  Deletes a participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(date)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end


  # def cancel_participation(participant) do
  #   participant
  #   |> Participant.changeset(%{"state" => "cancelled"})
  #   |> Repo.update()
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_participant(%Participant{} = participant) do
    Participant.changeset(participant, %{})
  end
end
