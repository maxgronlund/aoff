defmodule AOFF.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :price, :integer
      add :for_sale, :boolean, default: false
      add :show_on_landing_page, :boolean, default: false
      add :membership, :boolean, default: false

      timestamps()
    end

    create unique_index(:products, [:name])
  end
end
