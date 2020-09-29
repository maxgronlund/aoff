defmodule AOFF.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :text
      add :from, :string
      add :posted_at, :utc_datetime_usec
      add :committee_id, references(:commitee, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:messages, [:committee_id])
  end
end
