defmodule AOFF.Events.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Users.User
  alias AOFF.Content.Page

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "participants" do
    field :state, :string, default: "participating"
    belongs_to :user, User
    belongs_to :page, Page

    timestamps()
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:state, :user_id, :page_id])
    |> validate_required([:state, :user_id, :page_id])
  end
end
