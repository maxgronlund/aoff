defmodule AOFF.Committees do
  @moduledoc """
  The Committees context.
  """

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Committees.Committee
  alias AOFF.Committees.Member
  alias AOFF.Committees.Meeting

  @doc """
  Returns the list of committees.

  ## Examples

      iex> list_committees()
      [%Committee{}, ...]

  """
  def list_committees(prefix) do
    Repo.all(Committee, prefix: prefix)
  end

  @doc """
  Returns the list of public committees.

  ## Examples

      iex> list_committees(:public)
      [%Committee{}, ...]

  """
  def list_committees(prefix, :public) do
    query =
      from c in Committee,
        where: c.public_access == ^true

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns the list of committees with volunteer acces.

  ## Examples

      iex> list_committees(:public)
      [%Committee{}, ...]

  """
  def list_committees(prefix, :volunteer) do
    query =
      from c in Committee,
        where: c.volunteer_access == ^true

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns the list of member with volunteer acces.

  ## Examples

      iex> list_committees(:public)
      [%Committee{}, ...]

  """
  def list_committees(prefix, :member) do
    query =
      from c in Committee,
        where: c.member_access == ^true

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Returns the list of committees limited to commitees where the user is a member

  ## Examples

      iex> list_committees(USER_ID)
      [%Committee{}, ...]

  """

  def list_committees(prefix, user_id) do
    query =
      from c in Committee,
        join: mb in assoc(c, :members),
        where: mb.user_id == ^user_id

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Gets a single committee.

  Raises `Ecto.NoResultsError` if the Committee does not exist.

  ## Examples

      iex> get_committee!(123)
      %Committee{}

      iex> get_committee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_committee!(prefix, id) do
    query =
      from(
        c in Committee,
        where: c.id == ^id,
        select: c,
        preload: [
          members: [:user],
          meetings: ^from(m in Meeting, order_by: [desc: m.date])
        ]
      )

    Repo.one(query, prefix: prefix)
  end

  @doc """
  Creates a committee.

  ## Examples

      iex> create_committee(%{field: value})
      {:ok, %Committee{}}

      iex> create_committee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_committee(prefix, attrs \\ %{}) do
    %Committee{}
    |> Committee.changeset(attrs)
    |> Repo.insert(prefix: prefix)
  end

  @doc """
  Updates a committee.

  ## Examples

      iex> update_committee(committee, %{field: new_value})
      {:ok, %Committee{}}

      iex> update_committee(committee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_committee(%Committee{} = committee, attrs) do
    committee
    |> Committee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a committee.

  ## Examples

      iex> delete_committee(committee)
      {:ok, %Committee{}}

      iex> delete_committee(committee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_committee(%Committee{} = committee) do
    Repo.delete(committee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking committee changes.

  ## Examples

      iex> change_committee(committee)
      %Ecto.Changeset{source: %Committee{}}

  """
  def change_committee(%Committee{} = committee) do
    Committee.changeset(committee, %{})
  end

  @doc """
  Returns the list of meetings.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_meetings(prefix) do
    Repo.all(Meeting, prefix: prefix)
  end

  @doc """
  Returns a list of meetings for a given user.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_user_meetings(prefix, user_id, today) do
    query =
      from mt in Meeting,
        where: mt.date >= ^today,
        join: c in assoc(mt, :committee),
        join: mb in assoc(c, :members),
        where: mb.user_id == ^user_id,
        distinct: true

    meetings =
      query
      |> Repo.all(prefix: prefix)
      |> Repo.preload(:committee)

    if Enum.any?(meetings), do: meetings, else: false
  end

  @doc """
  Gets a single meeting.

  Raises `Ecto.NoResultsError` if the Meeting does not exist.

  ## Examples

      iex> get_meeting!(123)
      %Meeting{}

      iex> get_meeting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting!(prefix, id) do
    Repo.get!(Meeting, id, prefix: prefix)
    |> Repo.preload(:moderator)
    |> Repo.preload(:minutes_taker)
    |> Repo.preload(committee: [:members])
  end

  @doc """
  Creates a meeting.

  ## Examples

      iex> create_meeting(%{field: value})
      {:ok, %Meeting{}}

      iex> create_meeting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting(prefix, attrs \\ %{}) do
    %Meeting{}
    |> Meeting.changeset(attrs)
    |> Repo.insert(prefix: prefix)
  end

  @doc """
  Updates a meeting.

  ## Examples

      iex> update_meeting(meeting, %{field: new_value})
      {:ok, %Meeting{}}

      iex> update_meeting(meeting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting.

  ## Examples

      iex> delete_meeting(meeting)
      {:ok, %Meeting{}}

      iex> delete_meeting(meeting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.

  ## Examples

      iex> change_meeting(meeting)
      %Ecto.Changeset{source: %Meeting{}}

  """
  def change_meeting(%Meeting{} = meeting) do
    Meeting.changeset(meeting, %{})
  end

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members(prefix, committee_id) do
    query =
      from m in Member,
        where: m.committee_id == ^committee_id

    Repo.all(query, prefix: prefix)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(prefix, id) do
    Member
    |> Repo.get!(id, prefix: prefix)
    |> Repo.preload(:committee)
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(prefix, attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert(prefix: prefix)
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end

  alias AOFF.Committees.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(prefix, committee_id) do
    query =
      from m in Message, where: m.committee_id == ^committee_id, order_by: [desc: m.posted_at]

    query
    |> Repo.all(prefix: prefix)
    |> Repo.preload(:committee)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(prefix, id) do
    Message
    |> Repo.get!(id, prefix: prefix)
    |> Repo.preload(committee: [:members])
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(prefix, attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert(prefix: prefix)
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
