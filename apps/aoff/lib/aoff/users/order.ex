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
    field :order_nr, :integer, default: 100
    field :payment_date, :date
    field :total, Money.Ecto.Amount.Type
    belongs_to :user, User
    has_many :order_items, OrderItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do

    order
    |> cast(attrs, [
      :user_id,
      :state,
      :order_nr,
      :payment_date,
      :total])
    |> validate_required([
      :user_id,
      :state,
      :order_nr])
  end
end
