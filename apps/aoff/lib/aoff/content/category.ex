defmodule AOFF.Content.Category do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Uploader.Image
  alias AOFF.Content.Page

  @derive {Phoenix.Param, key: :title}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :description, :string
    field :title, :string
    field :image, Image.Type
    field :identifier, :string
    field :locale, :string, default: "da"
    field :position, :integer, default: 0
    field :publish, :boolean, default: true
    has_many :pages, Page
    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :description, :identifier, :locale, :position, :publish])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:title, :description, :identifier, :locale])
    |> validate_length(:title, min: 2, max: 253)
    |> unique_constraint(:identifier, name: :categories_identifier_locale_index)
    |> unique_constraint(:title, name: :categories_title_locale_index)
  end

  def image_url(post, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, post})
  end
end
