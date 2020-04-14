defmodule AOFF.Repo.Migrations.ModifyProducts do
  use Ecto.Migration

  def change do
    alter table("products") do
      add :this_weeks_content, :text
    end
  end
end
