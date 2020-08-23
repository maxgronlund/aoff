defmodule AOFF.Repo.Migrations.AddConfirmedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed_at, :date
    end
  end
end
