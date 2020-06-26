defmodule AOFF.Repo.Migrations.UpdateOrders do
  use Ecto.Migration


  def up do
    alter table(:orders) do
      modify :order_id, :string, default: ""
    end
  end

  def down do
    alter table(:orders) do
       modify :order_id, :integer, default: 0
    end
  end
end
