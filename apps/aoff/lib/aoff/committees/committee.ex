defmodule AOFF.Committees.Committee do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Committees.Member
  alias AOFF.Committees.Meeting

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "committees" do
    field :description, :string
    field :name, :string
    field :identifier

    has_many :members, Member
    has_many :meetings, Meeting

    timestamps()
  end

  @doc false
  def changeset(committee, attrs) do
    committee
    |> cast(attrs, [:name, :description, :identifier])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 2, max: 253)
  end
end
