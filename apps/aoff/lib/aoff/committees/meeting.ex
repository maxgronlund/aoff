defmodule AOFF.Committees.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "meetings" do
    field :description, :string
    field :name, :string
    field :summary, :string
    field :committee_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [
        :committee_id,
        :name,
        :description,
        :summary
      ]
    )
    |> validate_required([
        :committee_id,
        :name,
        :description,
        :summary
      ]
    )
  end
end
