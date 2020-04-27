defmodule AOFF.Committees.Meeting do
  use Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Committees.Committee

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "meetings" do
    field :agenda, :string
    field :location, :string
    field :name, :string
    field :summary, :string
    field :date, :date
    belongs_to :committee, Committee

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [
      :committee_id,
      :name,
      :date,
      :agenda,
      :summary,
      :location
    ])
    |> validate_required([
      :committee_id,
      :name,
      :date,
      :agenda,
      :location
    ])
  end
end
