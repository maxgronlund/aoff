defmodule AOFF.System.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :text, :string
    field :identifier, :string
    field :locale, :string, default: "da"
    field :show, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [
      :title,
      :identifier,
      :text,
      :show,
      :locale]
    )
    |> validate_required([
      :title,
      :identifier,
      :show,
      :locale]
    )
    |> unique_constraint(:identifier, name: :messages_identifier_locale_index)
  end
end
