defmodule AOFF.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :image, :string
      add :identifier, :string
      add :locale, :string, default: "da"
      add :description, :text
      add :position, :integer, default: 0

      timestamps()
    end

    create unique_index(:categories, [:identifier, :locale])
    create unique_index(:categories, [:title, :locale])
  end
end
