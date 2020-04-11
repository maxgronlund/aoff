defmodule AOFF.Repo.Migrations.UpdateDate do
  use Ecto.Migration

  def change do
    alter table(:dates) do
      add :open, :boolean, default: true
    end
  end
end
