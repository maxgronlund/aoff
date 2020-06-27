defmodule AOFF.Repo.Migrations.RemoveUniqIndexFromOrder do
  use Ecto.Migration

  def change do
    #drop unique_index(:orders, [:order_id])
  end
end
