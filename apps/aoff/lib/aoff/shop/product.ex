defmodule AOFF.Shop.Product do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Uploader.Image
  alias AOFF.Users.OrderItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :description_da, :string, default: ""
    field :description_en, :string, default: ""
    field :name_da, :string
    field :name_en, :string
    field :image, Image.Type
    field :price, Money.Ecto.Amount.Type
    field :for_sale, :boolean, default: false
    field :show_on_landing_page, :boolean, default: false
    field :membership, :boolean, default: false
    field :deleted, :boolean, default: false
    field :this_weeks_content_da, :string, default: ""
    field :this_weeks_content_en, :string, default: ""
    field :notes, :string, default: ""
    field :position, :integer, default: 0

    has_many :order_items, OrderItem

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name_da,
      :name_en,
      :description_da,
      :description_en,
      :price,
      :for_sale,
      :membership,
      :show_on_landing_page,
      :this_weeks_content_da,
      :this_weeks_content_en,
      :notes,
      :position
    ])
    |> cast_attachments(attrs, [:image])
    |> validate_required([
      :name_da,
      :name_en,
      :description_da,
      :description_en,
      :price,
      :for_sale,
      :membership,
      :show_on_landing_page
    ])
  end

  def delete_changeset(product, attrs) do
    product
    |> cast(attrs, [:deleted, :show_on_landing_page])
  end

  def image_url(product, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, product})
  end
end
