defmodule AOFF.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :string, default: "open"
      add :on_deleted_state, :string, default: "open"
      add :order_nr, :integer, default: 100
      add :order_id, :string, default: ""
      add :payment_date, :date
      add :card_nr, :string, default: ""
      add :total, :integer, default: 0
      add :token, :string
      add :paymenttype, :string, default: "1"
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:orders, [:token])
    create index(:orders, [:user_id])
  end
end
