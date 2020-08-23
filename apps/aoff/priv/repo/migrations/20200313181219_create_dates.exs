defmodule AOFF.Repo.Migrations.CreateDates do
  use Ecto.Migration

  def change do
    create table(:dates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :image, :string
      add :last_order_date, :date
      add :open, :boolean, default: true
      add :shop_assistant_a, :binary
      add :shop_assistant_b, :binary
      add :shop_assistant_c, :binary
      add :shop_assistant_d, :binary
      add :early_shift_from, :time, default: "~T[15:15:00]"
      add :early_shift_to, :time, default: "~T[17:15:00]"
      add :late_shift_from, :time, default: "~T[17:00:00]"
      add :late_shift_to, :time, default: "~T[18:00:00]"

      timestamps()
    end

    create unique_index(:dates, [:date])
  end
end
