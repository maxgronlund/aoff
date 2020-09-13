defmodule AOFF.Repo.Migrations.AddMailTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :unsubscribe_to_news_token, :string
    end
  end
end
