defmodule AOFF.Repo.Migrations.AddShowToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :publish, :boolean, default: true
    end
  end
end
