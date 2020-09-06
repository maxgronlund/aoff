defmodule AOFF.Repo.Migrations.AddParticipateToEventToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :signup_to_event, :boolean, default: false
    end
  end
end
