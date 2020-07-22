defmodule AOFF.Repo.Migrations.AddPublishToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :publish, :boolean, default: true
    end
  end
end
