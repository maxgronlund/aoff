defmodule AOFF.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :title, :string
      add :image, :string
      add :caption, :string
      add :teaser, :text
      add :text, :text
      add :author, :string
      add :tag, :string
      add :show_on_landing_page, :boolean, default: false
      add :locale, :string, default: "da"
      add :position, :integer, default: 0
      add :category_id, references(:categories, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:pages, [:category_id, :title])
  end
end
