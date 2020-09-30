defmodule AOFF.Committees.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Committees.Committee

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "committee_messages" do
    field :body, :string
    field :from, :string
    field :posted_at, :utc_datetime_usec
    field :title, :string
    belongs_to :committee, Committee

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    attrs = Map.put(attrs, "posted_at", AOFF.Time.now())

    message
    |> cast(attrs, [:title, :body, :from, :posted_at, :committee_id])
    |> validate_required([:title, :body, :from, :committee_id])
  end
end
