defmodule AOFF.Repo.Migrations.AddPositionToBlogs do
  use Ecto.Migration

  def change do
    alter table("blogs") do
      add :position, :integer, default: 0
    end
  end
end
