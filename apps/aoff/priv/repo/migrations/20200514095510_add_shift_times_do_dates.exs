defmodule AOFF.Repo.Migrations.AddShiftTimesDoDates do
  use Ecto.Migration

  def change do
    alter table("dates") do
      add :early_shift_from, :time, default: "~T[15:15:00]"
      add :early_shift_to, :time, default: "~T[17:15:00]"
      add :late_shift_from, :time, default: "~T[17:00:00]"
      add :late_shift_to, :time, default: "~T[18:00:00]"
    end
  end
end
