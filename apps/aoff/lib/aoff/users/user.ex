defmodule AOFF.Users.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias AOFF.Users
  alias AOFF.Users.Order
  alias AOFF.Shop.PickUp
  alias AOFF.Uploader.Image
  alias AOFF.Events.Participant

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
    field :confirm_account, :boolean, virtual: true
    field :confirmed_at, :date
    field :subscribe_to_news, :boolean, default: false
    field :unsubscribe_to_news_token, :string

    has_many :orders, Order
    has_many :pick_ups, PickUp
    has_many :participants, Participant

    # has_many :meetings, AOFF.Committees.Meeting

    timestamps()
  end

  def confirmation_changeset(user, attrs) do
    user
    |> cast(attrs, [:confirmed_at])
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
  def volunteer_changeset(user, prefix, attrs) do
    attrs =
      Map.merge(
        attrs,
        %{
          "member_nr" => last_member_nr(prefix, attrs) + 1,
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
      :manage_membership,
      :unsubscribe_to_news_token,
      :confirm_account
    ])
    |> validate(attrs)
    |> put_confirmed_at()
    |> cast_attachments(attrs, [:avatar])
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
      :manage_membership,
      :subscribe_to_news,
      :unsubscribe_to_news_token,
      :confirm_account
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
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:username, min: 2, max: 253)
    |> validate_length(:email, min: 2, max: 253)
    |> validate_length(:mobile, min: 8, max: 15)
    |> validate_length(:mobile_country_code, min: 2, max: 3)
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> put_confirmed_at()
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
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:username, min: 2, max: 253)
    |> validate_length(:email, min: 2, max: 253)
    |> validate_length(:mobile, min: 8, max: 15)
    |> validate_length(:mobile_country_code, min: 2, max: 3)
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
      :manage_membership,
      :subscribe_to_news,
      :unsubscribe_to_news_token,
      :confirm_account
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
    |> validate_length(:username, min: 2, max: 253)
    |> validate_length(:email, min: 2, max: 253)
    |> validate_length(:mobile, min: 8, max: 15)
    |> validate_length(:mobile_country_code, min: 2, max: 3)
    |> put_confirmed_at()
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
      :password_reset_expires,
      :subscribe_to_news,
      :unsubscribe_to_news_token
    ])
    |> validate_required([
      :username,
      :email,
      :password
    ])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:username, min: 2, max: 253)
    |> validate_length(:email, min: 2, max: 253)
    |> validate_length(:mobile, min: 8, max: 15)
    |> validate_length(:mobile_country_code, min: 2, max: 3)
    |> put_pass_hash()
    |> cast_attachments(attrs, [:avatar])
  end

  def registration_changeset(user, prefix, attrs) do
    attrs =
      Map.merge(
        attrs,
        %{
          "member_nr" => last_member_nr(prefix, attrs) + 1,
          "registration_date" => AOFF.Time.today(),
          "password_reset_token" => Ecto.UUID.generate(),
          "password_reset_expires" => AOFF.Time.now()
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
      :registration_date,
      :password_reset_token,
      :password_reset_expires,
      :subscribe_to_news,
      :unsubscribe_to_news_token
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
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:username, min: 2, max: 253)
    |> validate_length(:email, min: 2, max: 253)
    |> validate_length(:mobile, min: 8, max: 15)
    |> validate_length(:mobile_country_code, min: 2, max: 3)
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> cast_attachments(attrs, [:avatar])
  end

  def unsubscribe_to_news_change(user, attrs) do
    user
    |> cast(
      attrs,
      [
        :unsubscribe_to_news_token,
        :subscribe_to_news
      ]
    )
  end

  def last_member_nr(prefix, attrs) do
    Users.last_member_nr(prefix) || attrs["member_nr"] || 0
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
      :username,
      :subscribe_to_news,
      :unsubscribe_to_news_token,
      :confirm_account
    ])
    |> validate_required([
      :id,
      :email,
      :username
    ])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
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

  defp put_confirmed_at(changeset) do
    case fetch_field(changeset, :confirm_account) do
      {:data, nil} ->
        changeset

      _ ->
        put_change(changeset, :confirmed_at, AOFF.Time.today())
    end
  end

  def image_url(user, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, user})
  end
end
