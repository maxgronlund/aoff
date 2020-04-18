defmodule AOFF.Shop.Date do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Shop.PickUp
  alias AOFF.Uploader.Image

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "dates" do
    field :date, :date
    field :last_order_date, :date
    field :image, Image.Type
    field :open, :boolean, default: true
    field :shop_assistant_a, :binary
    field :shop_assistant_b, :binary
    field :shop_assistant_c, :binary
    field :shop_assistant_d, :binary
    has_many :pick_ups, PickUp

    timestamps()
  end

  @doc false
  def changeset(date, attrs) do
    date
    |> cast(attrs, [
      :date,
      :last_order_date,
      :open,
      :shop_assistant_a,
      :shop_assistant_b,
      :shop_assistant_c,
      :shop_assistant_d
    ])
    |> validate_required([
      :date,
      :last_order_date
    ])
    |> unique_constraint(:date)
    |> cast_attachments(attrs, [:image])
  end

  def build_defaults() do
    for year <- 2020..2029, month <- 1..11, date <- 1..31 do
      case Date.new(year, month, date) do
        {:ok, date} ->
          if Date.day_of_week(date) == 3 do
            if Date.compare(date, Date.utc_today()) == :gt do
              AOFF.Shop.create_date(%{
                "date" => date,
                "last_order_date" => Date.add(date, -4),
                "open" => true
              })
            end
          end

        _ ->
          "not a date"
      end
    end
  end

  def image_url(user, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, user})
  end
end
