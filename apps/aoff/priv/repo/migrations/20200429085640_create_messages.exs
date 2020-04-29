defmodule AOFF.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :body, :text

      timestamps()
    end

  end
end
