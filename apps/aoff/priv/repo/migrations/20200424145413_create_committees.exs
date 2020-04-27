defmodule AOFF.Repo.Migrations.CreateCommittees do
  use Ecto.Migration

  def change do
    create table(:committees, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :identifier, :text

      timestamps()
    end
  end
end
