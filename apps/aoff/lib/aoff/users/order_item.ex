defmodule AOFF.Users.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Users.User
  alias AOFF.Users.Order
  alias AOFF.Shop.Product
  alias AOFF.Shop.Date
  alias AOFF.Shop.PickUp

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "order_items" do
    field :state, :string, default: "initial"
    field :price, Money.Ecto.Amount.Type
    belongs_to :order, Order
    belongs_to :date, Date
    belongs_to :product, Product
    belongs_to :user, User
    belongs_to :pick_up, PickUp

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [
      :state,
      :order_id,
      :date_id,
      :user_id,
      :product_id,
      :pick_up_id,
      :price
    ])
    |> validate_required([
      :state,
      :order_id,
      :date_id,
      :user_id,
      :product_id,
      :pick_up_id,
      :price
    ])
  end

  def update_changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [
      :state
    ])
    |> validate_required([:state])
  end
end
