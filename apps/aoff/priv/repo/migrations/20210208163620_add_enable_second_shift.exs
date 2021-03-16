defmodule AOFF.Repo.Migrations.AddEnableSecondShift do
  use Ecto.Migration

  def change do
    alter table(:dates) do
      add :enable_second_shift, :boolean, default: true
    end
  end
end
