defmodule AOFF.Repo.Migrations.AddDateToMeetings do
  use Ecto.Migration

  def change do
    alter table("meetings") do
      add :date, :date
      add :agenda, :text
      add :location, :text
      remove :description, :text
    end
  end
end
