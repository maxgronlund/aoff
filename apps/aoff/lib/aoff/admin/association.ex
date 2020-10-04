defmodule AOFF.Admin.Association do
  use Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "associations" do
    field :name, :string
    field :contact_person_1_title, :string
    field :contact_person_2_title, :string
    belongs_to :contact_person_1, User
    belongs_to :contact_person_2, User

    timestamps()
  end

  @doc false
  def changeset(association, attrs) do
    association
    |> cast(
      attrs,
      [
        :name,
        :contact_person_1_title,
        :contact_person_2_title,
        :contact_person_1_id,
        :contact_person_2_id
      ]
    )
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
