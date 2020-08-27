defmodule AOFF.Committees.Meeting do
  use Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Committees.Committee
  alias AOFF.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "meetings" do
    field :agenda, :string
    field :location, :string
    field :name, :string
    field :summary, :string
    field :date, :date
    field :time, :time
    belongs_to :committee, Committee
    belongs_to :moderator, User
    belongs_to :minutes_taker, User

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [
      :committee_id,
      :moderator_id,
      :minutes_taker_id,
      :name,
      :date,
      :time,
      :agenda,
      :summary,
      :location
    ])
    |> validate_length(:name, min: 2, max: 253)
    |> validate_required([
      :committee_id,
      :name,
      :date,
      :time
    ])
  end
end
