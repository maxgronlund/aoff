defmodule AOFF.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name_da, :string
      add :description_da, :text, default: ""
      add :this_weeks_content_da, :text, default: ""
      add :name_en, :string
      add :description_en, :text, default: ""
      add :this_weeks_content_en, :text, default: ""
      add :notes, :text, default: ""
      add :image, :string
      add :price, :integer
      add :for_sale, :boolean, default: false
      add :collection, :boolean, default: false
      add :show_on_landing_page, :boolean, default: false
      add :membership, :boolean, default: false
      add :deleted, :boolean, default: false
      add :position, :integer, default: 0

      timestamps()
    end
  end
end
