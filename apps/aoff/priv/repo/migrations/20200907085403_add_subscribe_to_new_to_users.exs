defmodule AOFF.Repo.Migrations.AddSubscribeToNewToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :subscribe_to_news, :boolean, default: false
    end
  end
end
