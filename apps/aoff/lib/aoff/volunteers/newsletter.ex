defmodule AOFF.Volunteer.Newsletter do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Uploader.Image

  @primary_key {
    :id,
    :binary_id,
    autogenerate: true
  }
  @foreign_key_type :binary_id
  schema "newsletters" do
    field :author, :string
    field :caption, :string
    field :date, :date
    field :image, Image.Type
    field :send, :boolean, default: false
    field :text, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(newsletter, attrs) do
    newsletter
    |> cast(
      attrs,
      [
        :date,
        :title,
        :caption,
        :text,
        :author,
        :send
      ]
    )
    |> validate_required([
      :date,
      :title,
      :text,
      :author,
      :send
    ])
    |> cast_attachments(attrs, [:image])
  end
end
