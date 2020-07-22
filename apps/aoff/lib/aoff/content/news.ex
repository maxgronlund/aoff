defmodule AOFF.Content.News do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Uploader.Image

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "news" do
    field :author, :string
    field :caption, :string
    field :date, :date
    field :image, Image.Type
    field :teaser, :string
    field :text, :string
    field :title, :string
    field :show_on_landing_page, :boolean, default: false
    field :locale, :string, default: "da"
    field :publish, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :date,
      :title,
      :caption,
      :teaser,
      :text,
      :author,
      :show_on_landing_page,
      :locale,
      :publish
    ])
    |> cast_attachments(attrs, [:image])
    |> validate_required([
      :date,
      :title,
      :text,
      :author,
      :show_on_landing_page
    ])
  end

  def image_url(post, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, post})
  end
end
