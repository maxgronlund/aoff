defmodule AOFF.Repo.Migrations.AddAccessToCommittees do
  use Ecto.Migration

  def change do
    alter table(:committees) do
      add :public_access, :boolean, default: false
      add :volunteer_access, :boolean, default: false
      add :member_access, :boolean, default: false
    end
  end
end
