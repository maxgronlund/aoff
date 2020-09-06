defmodule AOFF.Repo.Migrations.CreateNewsletters do
  use Ecto.Migration

  def change do
    create table(:newsletters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :title, :string
      add :image, :string
      add :caption, :string
      add :text, :text
      add :author, :string
      add :send, :boolean, default: false, null: false

      timestamps()
    end

  end
end
