defmodule AOFF.Repo.Migrations.AddParticipantsToParticipants do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :participants, :integer, default: 1
    end
  end
end
