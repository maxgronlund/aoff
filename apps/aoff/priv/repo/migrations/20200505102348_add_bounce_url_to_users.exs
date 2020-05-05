defmodule AOFF.Repo.Migrations.AddBounceUrlToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :bounce_to_url, :string, default: ""
    end
  end
end
