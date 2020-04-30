defmodule AOFF.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :body, :text
      add :posted_at, :naive_datetime
      add :posted, :string

      add :committee_id, references(:committees, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:chat_messages, [:committee_id])

  end
end
