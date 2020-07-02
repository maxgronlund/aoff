defmodule AOFF.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      # add :state, :string, default: "initial"
      add :price, :integer, default: 0
      add :order_id, references(:orders, delete_all: :delete_all, type: :binary_id)
      add :date_id, references(:dates, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id)
      add :pick_up_id, references(:pick_ups, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:order_items, [:order_id])
    create index(:order_items, [:date_id])
    create index(:order_items, [:user_id])
    create index(:order_items, [:product_id])
    create index(:order_items, [:pick_up_id])
  end
end
