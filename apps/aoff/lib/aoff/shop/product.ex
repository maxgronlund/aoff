defmodule AOFF.Shop.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Users.OrderItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :description, :string
    field :name, :string
    field :price, Money.Ecto.Amount.Type
    field :for_sale, :boolean, default: false
    field :show_on_landing_page, :boolean, default: false
    field :membership, :boolean, default: false

    has_many :order_items, OrderItem

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :description,
      :price,
      :for_sale,
      :membership,
      :show_on_landing_page]
    )
    |> validate_required([
      :name,
      :price,
      :for_sale,
      :membership,
      :show_on_landing_page]
    )
    |> unique_constraint(:name)
  end
end
