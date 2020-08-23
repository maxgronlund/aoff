defmodule AOFF.Users.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Users.User
  alias AOFF.Users.OrderItem
  alias AOFF.Shop.PickUp

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :state, :string, default: "open"
    field :on_deleted_state, :string, default: "open"
    field :order_nr, :integer
    field :order_id, :string, default: ""
    field :token, :string
    field :payment_date, :date
    field :paymenttype, :string, default: "1"
    field :card_nr, :string, default: ""
    field :total, Money.Ecto.Amount.Type
    belongs_to :user, User
    has_many :order_items, OrderItem
    has_many :pick_ups, PickUp

    timestamps()
  end

  @doc false
  def create_changeset(order, attrs) do
    attrs =
      attrs
      |> Map.merge(%{
        "token" => AOFF.Token.generate(),
        "total" => Money.new(0, :DKK)
      })

    order
    |> cast(attrs, [
      :user_id,
      :token,
      :total,
      :state,
      :payment_date,
      :paymenttype,
      :card_nr
    ])
    |> validate_required([
      :user_id,
      :state,
      :token
    ])
    |> unique_constraint(:token)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :user_id,
      :state,
      :on_deleted_state,
      :order_nr,
      :order_id,
      :token,
      :payment_date,
      :paymenttype,
      :total,
      :card_nr
    ])
    |> validate_required([:user_id, :state, :token])
  end
end
