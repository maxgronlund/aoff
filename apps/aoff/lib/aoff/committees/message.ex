defmodule AOFF.Committees.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :body, :string
    field :from, :string
    field :posted_at, :utc_datetime_usec
    field :title, :string
    field :committee_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:title, :body, :from, :posted_at])
    |> validate_required([:title, :body, :from, :posted_at])
  end
end
