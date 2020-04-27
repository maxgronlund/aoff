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
    field :token, :string
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
        "token" => AOFF.Token.generate(),
        "order_nr" => Users.last_order_nr() + 1,
        "total" => Money.new(0, :DKK)
      })

    order
    |> cast(attrs, [
      :user_id,
      :order_nr,
      :token,
      :total
    ])
    |> validate_required([
      :user_id,
      :order_nr,
      :state,
      :token
    ])
    |> unique_constraint(:token)
    |> unique_constraint(:order_nr)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :state, :order_nr, :token, :payment_date, :total])
    |> validate_required([:user_id, :state, :token])
  end
end
