defmodule AOFF.Committees.Committee do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Committees.Member

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "committees" do
    field :description, :string
    field :name, :string
    field :identifier

    has_many :members, Member

    timestamps()
  end

  @doc false
  def changeset(committee, attrs) do
    committee
    |> cast(attrs, [:name, :description, :identifier])
    |> validate_required([:name, :description])
  end
end
