defmodule AOFF.Repo.Migrations.AddIndexToOrders do
  use Ecto.Migration

  def up do
    alter table("orders") do
      modify :order_nr, :integer, default: nil
    end

    create unique_index(:orders, [:order_id])

    alter table("order_items") do
      remove :state, :string
    end
  end

  def down do
    alter table("orders") do
      modify :order_nr, :integer, default: 100
    end

    alter table("order_items") do
      add :state, :string, default: "initial"
    end
  end
end
