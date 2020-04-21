defmodule AOFF.Users.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Users.User
  alias AOFF.Users
  alias AOFF.Users.OrderItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :state, :string, default: "open"
    field :order_nr, :integer
    field :order_id, :integer
    field :payment_date, :date
    field :total, Money.Ecto.Amount.Type
    belongs_to :user, User
    has_many :order_items, OrderItem

    timestamps()
  end

  @doc false
  def create_changeset(order, attrs) do
    attrs =
      attrs
      |> Map.merge(%{
        "order_id" => Users.last_order_id() + 1,
        "total" => Money.new(0, :DKK)
      })

    order
    |> cast(attrs, [
      :user_id,
      :order_id,
      :total
    ])
    |> validate_required([
      :user_id,
      :state,
      :order_id
    ])
    |> unique_constraint(:order_id)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :user_id,
      :state,
      :order_nr,
      :order_id,
      :payment_date,
      :total]
    )
    |> validate_required([
      :user_id,
      :state,
      :order_id]
    )
  end
end
