defmodule AOFF.Repo.Migrations.AddOpeningTimeToDate do
  use Ecto.Migration

  def change do
    alter table(:dates) do
      add :open_from, :time, default: "~T[16:00:00]"
      add :close_at, :time, default: "~T[18:00:00]"

      # add :early_apprentice_id, references(:users, on_delete: :nothing, type: :binary_id)
      # add :late_apprentice_id, references(:users, on_delete: :nothing, type: :binary_id)
    end
  end
end
