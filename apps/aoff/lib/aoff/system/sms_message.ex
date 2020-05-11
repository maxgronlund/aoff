defmodule AOFF.System.SMSMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sms_messages" do
    field :mobile, :string
    field :text, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(sms_message, attrs) do
    sms_message
    |> cast(attrs, [:mobile, :text, :user_id])
    |> validate_required([:mobile, :text, :user_id])
  end
end
