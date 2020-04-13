defmodule AOFF.Repo.Migrations.CreatePickUps do
  use Ecto.Migration

  def change do
    create table(:pick_ups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :picked_up, :boolean, default: false, null: false
      add :date_id, references(:dates, on_delete: :nothing, type: :binary_id)
      add :username, :string
      add :email, :string
      add :member_nr, :integer
      add :order_id, references(:orders, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:pick_ups, [:date_id])
    create index(:pick_ups, [:user_id])
  end
end
