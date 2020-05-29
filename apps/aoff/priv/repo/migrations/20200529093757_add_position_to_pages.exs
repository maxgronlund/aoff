defmodule AOFF.Repo.Migrations.AddPositionToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :position, :integer, default: 0
    end
  end
end
