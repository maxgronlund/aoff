defmodule AOFF.Repo.Migrations.UpdateTextOnNews do
  use Ecto.Migration

  def up do
    alter table("news") do
      modify :text, :text
    end
  end

  def down do
    alter table("news") do
      modify :text, :string
    end
  end
end
