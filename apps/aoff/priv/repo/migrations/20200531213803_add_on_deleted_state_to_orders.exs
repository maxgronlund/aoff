defmodule AOFF.Repo.Migrations.AddOnDeletedStateToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :on_deleted_state, :string, default: "open"
    end
  end
end
