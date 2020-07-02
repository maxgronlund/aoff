defmodule AOFF.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :summary, :text
      add :date, :date
      add :time, :time
      add :agenda, :text
      add :location, :text
      add :committee_id, references(:committees, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:meetings, [:committee_id])
  end
end
