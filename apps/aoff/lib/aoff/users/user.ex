defmodule AOFF.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Users
  alias AOFF.Users.Order
  alias AOFF.Shop.PickUp

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :member_nr, :integer
    field :username, :string
    field :email, :string
    field :mobile, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :months, :integer, default: 12
    field :expiration_date, :date
    field :admin, :boolean, default: false
    field :volunteer, :boolean, default: false
    field :purchasing_manager, :boolean, default: false
    field :shop_assistant, :boolean, default: false

    has_many :orders, Order
    has_many :pick_ups, PickUp

    timestamps()
  end

  @doc false
  def volunteer_update_changeset(user, attrs) do
    admin_update_changeset(
      user,
      Map.drop(attrs, [:admin, "admin"])
    )
  end

  @doc false
  def admin_update_changeset(user, attrs) do
    case String.trim(attrs["password"] || "") do
      "" ->
        admin_changeset_without_password(user, attrs)

      _ ->
        admin_changeset(user, attrs)
    end
  end

  @doc false
  def admin_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :id,
      :email,
      :username,
      :member_nr,
      :password,
      :mobile,
      :months,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant
    ])
    |> validate_required([
      :username,
      :email,
      :member_nr,
      :password,
      :months,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant
    ])
    |> validate_confirmation(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp admin_changeset_without_password(user, attrs) do
    user
    |> cast(attrs, [
      :id,
      :email,
      :mobile,
      :username,
      :member_nr,
      :months,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant
    ])
    |> validate_required([
      :username,
      :email,
      :member_nr,
      :months,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant
    ])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_confirmation(:email)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :id,
      :email,
      :mobile,
      :username,
      :password
    ])
    |> validate_required([
      :username,
      :email,
      :password
    ])
    |> validate_confirmation(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def registration_changeset(user, attrs) do
    last_member_nr = Users.last_member_nr() || attrs["member_nr"] || 0

    attrs =
      Map.merge(
        attrs,
        %{
          "member_nr" => last_member_nr + 1,
          "expiration_date" => ~D[2020-01-01],
          "months" => 0
        }
      )

    user
    |> cast(attrs, [
      :id,
      :email,
      :username,
      :password,
      :mobile,
      :member_nr,
      :expiration_date,
      :months
    ])
    |> validate_required([
      :username,
      :email,
      :password,
      :member_nr,
      :expiration_date,
      :months
    ])
    |> validate_confirmation(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  @doc false
  def update_changeset(user, attrs) do
    case String.trim(attrs["password"] || "") do
      "" ->
        changeset_without_password(user, attrs)

      _ ->
        changeset(user, attrs)
    end
  end

  defp changeset_without_password(user, attrs) do
    user
    |> cast(attrs, [
      :id,
      :email,
      :mobile,
      :username
    ])
    |> validate_required([
      :id,
      :email,
      :username
    ])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_confirmation(:email)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
