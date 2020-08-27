defmodule AOFF.Content.Page do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Uploader.Image
  alias AOFF.Content.Category
  @derive {Phoenix.Param, key: :title}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pages" do
    field :author, :string
    field :caption, :string
    field :date, :date
    field :image, Image.Type
    field :teaser, :string
    field :text, :string
    field :title, :string
    field :tag, :string
    field :show_on_landing_page, :boolean, default: false
    field :locale, :string, default: "da"
    field :position, :integer, default: 0
    field :publish, :boolean, default: true
    belongs_to :category, Category
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :category_id,
      :date,
      :title,
      :caption,
      :teaser,
      :text,
      :author,
      :tag,
      :show_on_landing_page,
      :locale,
      :position,
      :publish
    ])
    |> cast_attachments(attrs, [:image])
    |> validate_required([
      :category_id,
      :date,
      :title,
      :teaser,
      :text,
      :author,
      :show_on_landing_page,
      :position
    ])
    |> validate_length(:title, min: 2, max: 253)
    |> unique_constraint(:title, name: :pages_category_id_title_index)
  end

  def image_url(post, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, post})
  end
end
