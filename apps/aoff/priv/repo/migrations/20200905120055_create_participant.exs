defmodule AOFF.Repo.Migrations.CreateParticipant do
  use Ecto.Migration

  def change do
    create table(:participants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :page_id, references(:pages, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      add :state, :string, default: "participating"

      timestamps()
    end

    create unique_index(:participants, [:page_id, :user_id])
  end
end
