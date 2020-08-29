defmodule AOFF.Repo.Migrations.DropNews do
  use Ecto.Migration

  def change do
    drop table(:news)
  end
end
