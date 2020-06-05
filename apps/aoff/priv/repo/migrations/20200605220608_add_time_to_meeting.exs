defmodule AOFF.Repo.Migrations.AddTimeToMeeting do
  use Ecto.Migration

  def change do
    alter table("meetings") do
      add :time, :time
    end
  end
end
