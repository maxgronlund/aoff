defmodule AOFF.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chat_messages" do
    field :body, :string
    field :username, :string
    field :posted_at, :naive_datetime
    field :posted, :string

    belongs_to :committee, Committee

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:username, :body, :posted_at, :committee_id, :posted])
    |> validate_required([:username, :body, :committee_id, :posted])
  end
end
