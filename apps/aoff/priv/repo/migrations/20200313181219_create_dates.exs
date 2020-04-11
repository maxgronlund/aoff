defmodule AOFF.Repo.Migrations.CreateDates do
  use Ecto.Migration

  def change do
    create table(:dates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :open, :boolean, default: true
      add :shop_assistant_a, :binary
      add :shop_assistant_b, :binary
      add :shop_assistant_c, :binary
      add :shop_assistant_d, :binary

      timestamps()
    end

    create unique_index(:dates, [:date])
  end
end
