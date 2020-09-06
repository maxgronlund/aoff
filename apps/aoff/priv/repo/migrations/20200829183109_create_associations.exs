defmodule AOFF.Repo.Migrations.CreateAssociations do
  use Ecto.Migration

  def change do
    create table(:associations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :contact_person_1_title, :string
      add :contact_person_2_title, :string
      add :contact_person_1_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :contact_person_2_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:associations, [:name])
  end
end
