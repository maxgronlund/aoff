defmodule AOFF.Repo.Migrations.AddIsSelectionToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :collection, :boolean, default: false
    end
  end
end
