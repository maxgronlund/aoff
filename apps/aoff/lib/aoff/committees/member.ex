defmodule AOFF.Committees.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Users.User
  alias AOFF.Committees.Committee

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "members" do
    field :role, :string

    belongs_to :user, User
    belongs_to :committee, Committee

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :user_id, :committee_id])
    |> validate_required([:role, :user_id, :committee_id])
  end
end
