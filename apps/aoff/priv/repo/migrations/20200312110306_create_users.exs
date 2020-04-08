defmodule AOFF.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :member_nr, :integer
      add :password_hash, :string
      add :email, :string
      add :mobile, :string
      add :months, :integer, default: 12
      add :expiration_date, :date
      add :admin, :boolean, default: false
      add :volunteer, :boolean, default: false
      add :purchasing_manager, :boolean, default: false
      add :shop_assistant, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:member_nr])
    create unique_index(:users, [:email])
  end
end
