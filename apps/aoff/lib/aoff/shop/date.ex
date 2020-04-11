defmodule AOFF.Shop.Date do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Shop.PickUp

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "dates" do
    field :date, :date
    field :open, :boolean, default: true
    field :shop_assistant_a, :binary
    field :shop_assistant_b, :binary
    field :shop_assistant_c, :binary
    field :shop_assistant_d, :binary
    has_many :pick_ups, PickUp

    timestamps()
  end

  @doc false
  def changeset(date, attrs) do
    date
    |> cast(attrs, [
      :date,
      :open,
      :shop_assistant_a,
      :shop_assistant_b,
      :shop_assistant_c,
      :shop_assistant_d
    ])
    |> validate_required([
      :date
    ])
    |> unique_constraint(:date)
  end
end
