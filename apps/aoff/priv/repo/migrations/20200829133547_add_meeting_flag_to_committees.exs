defmodule AOFF.Repo.Migrations.AddMeetingFlagToCommittees do
  use Ecto.Migration

  def change do
    alter table(:committees) do
      add :enable_meetings, :boolean, default: true
    end
  end
end
