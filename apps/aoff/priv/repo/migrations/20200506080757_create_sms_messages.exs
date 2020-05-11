defmodule AOFF.Repo.Migrations.CreateSmsMessages do
  use Ecto.Migration

  def change do
    create table(:sms_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :mobile, :string
      add :text, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:sms_messages, [:user_id])
  end
end
