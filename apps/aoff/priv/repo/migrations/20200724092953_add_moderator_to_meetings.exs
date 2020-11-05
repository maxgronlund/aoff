defmodule AOFF.Repo.Migrations.AddModeratorToMeetings do
  use Ecto.Migration

  def change do
    alter table(:meetings) do
      # add :moderator_id, references(:users, on_delete: :nothing, type: :binary_id)
      # add :minutes_taker_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :moderator_id, references(:users, on_delete: :nilify_all, type: :binary_id)
      add :minutes_taker_id, references(:users, on_delete: :nilify_all, type: :binary_id)
    end
  end
end
