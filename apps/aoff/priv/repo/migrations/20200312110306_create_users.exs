defmodule AOFF.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :avatar, :string
      add :member_nr, :integer
      add :password_hash, :string
      add :password_reset_token, :string
      add :password_reset_expires, :utc_datetime_usec
      add :email, :string
      add :mobile, :string
      add :mobile_country_code, :string, default: "45"
      add :expiration_date, :date
      add :admin, :boolean, default: false
      add :volunteer, :boolean, default: false
      add :purchasing_manager, :boolean, default: false
      add :shop_assistant, :boolean, default: false
      add :terms_accepted, :boolean, default: false
      add :registration_date, :date
      add :bounce_to_url, :string, default: ""
      add :text_editor, :boolean, default: false
      add :manage_membership, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:member_nr])
    create unique_index(:users, [:email])
  end
end
