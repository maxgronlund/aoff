defmodule AOFF.Repo.Migrations.FixProductDescription do
  use Ecto.Migration

  def up do
    alter table("products") do
      modify :description, :text, default: ""
      modify :this_weeks_content, :text, default: ""
      add :notes, :text, default: ""
    end
  end

  def down do
    alter table("products") do
      modify :description, :text
      modify :this_weeks_content, :text
      remove :notes, :text
    end
  end
end
