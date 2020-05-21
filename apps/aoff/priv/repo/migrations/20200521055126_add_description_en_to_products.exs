defmodule AOFF.Repo.Migrations.AddDescriptionEnToProducts do
  use Ecto.Migration

  def change do
    rename table(:products), :name, to: :name_da
    rename table(:products), :description, to: :description_da
    rename table(:products), :this_weeks_content, to: :this_weeks_content_da

    alter table(:products) do
      add :name_en, :string, default: ""
      add :description_en, :string, default: ""
      add :this_weeks_content_en, :string, default: ""
    end
  end
end
