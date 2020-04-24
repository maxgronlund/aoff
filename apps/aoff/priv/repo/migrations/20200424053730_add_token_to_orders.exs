defmodule AOFF.Repo.Migrations.AddTokenToOrders do
  use Ecto.Migration

  def up do
    alter table("orders") do
      add :token, :string
    end

    create unique_index(:orders, [:token])
  end

  def down do
    alter table("orders") do
      remove :token, :string
    end
  end
end
