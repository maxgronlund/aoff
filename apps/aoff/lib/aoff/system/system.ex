defmodule AOFF.System do
  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.System.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages("da")
      [%Message{}, ...]

  """
  def list_messages(locale \\ "da") do
    query =
      from m in Message,
        where: m.locale == ^locale

    query
    |> Repo.all()
  end

  def find_or_create_message(identifier, title, locale \\ "da") do
    query =
      from m in Message,
        where: m.identifier == ^identifier and m.locale == ^locale,
        limit: 1

    case Repo.one(query) do
      nil ->
        create_message(%{
          "title" => title,
          "text" => "-",
          "identifier" => identifier,
          "locale" => locale
        })

      %Message{} = message ->
        {:ok, message}
    end
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
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
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
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end


  alias AOFF.System.SMSMessage

  @doc """
  Returns the list of sms_messages.

  ## Examples

      iex> list_sms_messages()
      [%SMSMessage{}, ...]

  """
  def list_sms_messages do
    Repo.all(SMSMessage)
  end

  @doc """
  Gets a single sms_message.

  Raises `Ecto.NoResultsError` if the Sms message does not exist.

  ## Examples

      iex> get_sms_message!(123)
      %SMSMessage{}

      iex> get_sms_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sms_message!(id), do: Repo.get!(SMSMessage, id)

  @doc """
  Creates a sms_message.

  ## Examples

      iex> create_sms_message(%{field: value})
      {:ok, %SMSMessage{}}

      iex> create_sms_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sms_message(attrs \\ %{}) do
    %SMSMessage{}
    |> SMSMessage.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Deletes a sms_message.

  ## Examples

      iex> delete_sms_message(sms_message)
      {:ok, %SMSMessage{}}

      iex> delete_sms_message(sms_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sms_message(%SMSMessage{} = sms_message) do
    Repo.delete(sms_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sms_message changes.

  ## Examples

      iex> change_sms_message(sms_message)
      %Ecto.Changeset{source: %SMSMessage{}}

  """
  def change_sms_message(%SMSMessage{} = sms_message) do
    SMSMessage.changeset(sms_message, %{})
  end

end
