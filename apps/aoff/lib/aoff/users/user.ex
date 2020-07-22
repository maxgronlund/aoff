defmodule AOFF.Users.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Users
  alias AOFF.Users.Order
  alias AOFF.Shop.PickUp
  alias AOFF.Uploader.Image

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :member_nr, :integer
    field :username, :string
    field :avatar, Image.Type
    field :email, :string
    field :password_reset_token, :string
    field :password_reset_expires, :utc_datetime_usec
    field :mobile, :string
    field :mobile_country_code, :string, default: "45"
    field :password, :string, virtual: true
    field :password_hash, :string
    field :expiration_date, :date
    field :admin, :boolean, default: false
    field :volunteer, :boolean, default: false
    field :purchasing_manager, :boolean, default: false
    field :shop_assistant, :boolean, default: false
    field :text_editor, :boolean, default: false
    field :terms_accepted, :boolean, default: false
    field :registration_date, :date
    field :manage_membership, :boolean, default: false
    field :bounce_to_url, :string, default: "/"

    has_many :orders, Order
    has_many :pick_ups, PickUp

    timestamps()
  end

  def bounce_to_changeset(user, attrs) do
    user
    |> cast(attrs, [:bounce_to_url])
    |> validate_required([:bounce_to_url])
  end

  def update_membership_changeset(user, attrs) do
    user
    |> cast(attrs, [:expiration_date])
    |> validate_required([:expiration_date])
  end

  @doc false
  def password_reset_token_changeset(user, attrs) do
    user
    |> cast(attrs, [:password_reset_token, :password_reset_expires])
    |> validate_required([:password_reset_token, :password_reset_expires])
  end

  def update_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_reset_token])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> put_pass_hash()
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
  def volunteer_changeset(user, attrs) do
    attrs =
      Map.merge(
        attrs,
        %{
          "member_nr" => last_member_nr(attrs) + 1,
          "registration_date" => AOFF.Time.today()
        }
      )

    user
    |> cast(attrs, [
      :id,
      :email,
      :username,
      :member_nr,
      :password,
      :mobile,
      :mobile_country_code,
      :expiration_date,
      :registration_date,
      :volunteer,
      :purchasing_manager,
      :shop_assistant,
      :text_editor,
      :manage_membership
    ])
    |> validate(attrs)
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
      :mobile_country_code,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant,
      :text_editor,
      :manage_membership
    ])
    |> validate_required([
      :username,
      :email,
      :member_nr,
      :password,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant,
      :text_editor,
      :manage_membership
    ])
    |> validate_confirmation(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> cast_attachments(attrs, [:avatar])
  end

  defp validate(user, _attrs) do
    user
    |> validate_required([
      :username,
      :email,
      :member_nr,
      :password,
      :expiration_date,
      :volunteer,
      :purchasing_manager,
      :shop_assistant,
      :text_editor,
      :manage_membership
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
      :mobile_country_code,
      :username,
      :member_nr,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant,
      :text_editor,
      :manage_membership
    ])
    |> validate_required([
      :username,
      :email,
      :member_nr,
      :expiration_date,
      :admin,
      :volunteer,
      :purchasing_manager,
      :shop_assistant,
      :text_editor,
      :manage_membership
    ])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_confirmation(:email)
    |> cast_attachments(attrs, [:avatar])
  end

  def import_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :member_nr,
      :username,
      :email,
      :mobile_country_code,
      :mobile,
      :password_hash,
      :registration_date,
      :expiration_date
    ])
    |> validate_required([
      :expiration_date,
      :registration_date
    ])
    |> unique_constraint(:member_nr)
    |> unique_constraint(:email)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :id,
      :email,
      :mobile,
      :mobile_country_code,
      :username,
      :password,
      :password_reset_token,
      :password_reset_expires
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
    |> cast_attachments(attrs, [:avatar])
  end

  def registration_changeset(user, attrs) do
    # last_member_nr = Users.last_member_nr() || attrs["member_nr"] || 0

    attrs =
      Map.merge(
        attrs,
        %{
          "member_nr" => last_member_nr(attrs) + 1,
          "registration_date" => AOFF.Time.today()
        }
      )

    user
    |> cast(attrs, [
      :id,
      :email,
      :username,
      :password,
      :mobile,
      :mobile_country_code,
      :member_nr,
      :expiration_date,
      :terms_accepted,
      :registration_date
    ])
    |> validate_required([
      :username,
      :email,
      :password,
      :member_nr,
      :expiration_date,
      :terms_accepted,
      :registration_date
    ])
    |> validate_acceptance(:terms_accepted)
    |> validate_confirmation(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> cast_attachments(attrs, [:avatar])
  end

  def last_member_nr(attrs) do
    Users.last_member_nr() || attrs["member_nr"] || 0
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
      :mobile_country_code,
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
    |> cast_attachments(attrs, [:avatar])
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def image_url(user, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, user})
  end
end
