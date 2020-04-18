defmodule AOFF.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :image, :string
      add :identifier, :string
      add :locale, :string, default: "da"
      add :description, :text

      timestamps()
    end

    create unique_index(:blogs, [:identifier, :locale])
    create unique_index(:blogs, [:title, :locale])
  end
end
