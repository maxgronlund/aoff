defmodule AOFF.Shop.PickUp do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Shop.Date
  alias AOFF.Users.User
  alias AOFF.Users.Order
  alias AOFF.Users.OrderItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pick_ups" do
    field :picked_up, :boolean, default: false
    field :username, :string
    field :email, :string
    field :member_nr, :integer
    field :send_sms_notification, :boolean
    belongs_to :date, Date
    belongs_to :user, User
    belongs_to :order, Order
    has_many :order_items, OrderItem

    timestamps()
  end

  @doc false
  def changeset(pick_up, attrs) do
    pick_up
    |> cast(attrs, [
        :picked_up,
        :date_id,
        :user_id,
        :order_id,
        :username,
        :email,
        :member_nr,
        :send_sms_notification
      ]
    )
    |> validate_required([
      :picked_up,
      :date_id,
      :user_id,
      :order_id,
      :username,
      :email,
      :member_nr
    ])
  end
end
