defmodule AOFF.Repo.Migrations.FixProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :this_weeks_content_en, :text
      modify :description_en, :text
    end
  end
end
