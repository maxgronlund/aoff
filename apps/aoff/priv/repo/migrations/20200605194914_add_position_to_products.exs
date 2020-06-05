defmodule AOFF.Repo.Migrations.AddPositionToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :position, :integer, default: 0
    end
  end
end
