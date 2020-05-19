defmodule AOFF.Repo.Migrations.CreateNews do
  use Ecto.Migration

  def change do
    create table(:news, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author, :string
      add :caption, :string
      add :date, :date
      add :image, :string
      add :teaser, :string
      add :text, :string
      add :title, :string
      add :show_on_landing_page, :boolean, default: false
      add :locale, :string, default: "da"

      timestamps()
    end
  end
end
