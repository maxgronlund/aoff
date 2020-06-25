defmodule AOFF.Repo.Migrations.AddCardNrToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :card_nr, :string, default: ""
      add :order_id, :string, default: ""
    end
  end
end
