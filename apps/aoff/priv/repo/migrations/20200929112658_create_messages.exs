defmodule AOFF.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:committee_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :text
      add :from, :string
      add :posted_at, :utc_datetime_usec
      add :committee_id, references(:committees, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:committee_messages, [:committee_id])
  end
end
