defmodule AOFF.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :string, default: "open"
      add :order_nr, :integer, default: 100
      add :payment_date, :date
      add :total, :integer, default: 0
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:orders, [:user_id])
  end
end
