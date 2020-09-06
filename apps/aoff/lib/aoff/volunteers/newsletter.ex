defmodule AOFF.Volunteer.Newsletter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {
      :id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "newsletters" do
    field :author, :string
    field :caption, :string
    field :date, :date
    field :image, :string
    field :send, :boolean, default: false
    field :text, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(newsletter, attrs) do
    newsletter
    |> cast(attrs,
      [
        :date,
        :title,
        :image,
        :caption,
        :text,
        :author,
        :send
      ]
    )
    |> validate_required(
      [
        :date,
        :title,
        :image,
        :caption,
        :text,
        :author,
        :send
      ]
    )
  end
end
