defmodule AOFF.Repo.Migrations.AddHostToAssociations do
  use Ecto.Migration

  def change do
    alter table(:associations) do
      add :host, :string, default: ""
      add :prefix, :string, default: "public"
    end
  end
end
