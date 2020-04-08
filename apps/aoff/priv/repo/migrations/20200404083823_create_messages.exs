defmodule AOFF.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :identifier, :string
      add :text, :text
      add :show, :boolean, default: false, null: false
      add :locale, :string, default: "da"

      timestamps()
    end

    create unique_index(:messages, [:identifier, :locale])

  end
end
