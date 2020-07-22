defmodule AOFF.Repo.Migrations.AddPublishToNews do
  use Ecto.Migration

  def change do
    alter table(:news) do
      add :publish, :boolean, default: true
    end
  end
end
