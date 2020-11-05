defmodule AOFF.Repo.Migrations.FixMeetingRefs do
  use Ecto.Migration

  def up do
    # execute "ALTER TABLE meetings DROP CONSTRAINT meetings_moderator_id_fkey"
    # execute "ALTER TABLE meetings DROP CONSTRAINT meetings_minutes_taker_id_fkey"

    # alter table(:meetings) do
    #   modify :moderator_id, references(:users, on_delete: :nilify_all, type: :binary_id)
    #   modify :minutes_taker_id, references(:users, on_delete: :nilify_all, type: :binary_id)
    # end
  end

  def down do
    # execute "ALTER TABLE meetings DROP CONSTRAINT meetings_moderator_id_fkey"
    # execute "ALTER TABLE meetings DROP CONSTRAINT meetings_minutes_taker_id_fkey"

    # alter table(:meetings) do
    #   modify :moderator_id, references(:users, on_delete: :nothing, type: :binary_id)
    #   modify :minutes_taker_id, references(:users, on_delete: :nothing, type: :binary_id)
    # end
  end
end
