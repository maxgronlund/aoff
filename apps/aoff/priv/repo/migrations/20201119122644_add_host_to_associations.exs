defmodule AOFF.Repo.Migrations.AddHostToAssociations do
  use Ecto.Migration

  def change do
    alter table(:associations) do
      add :host, :string, default: ""
    end
  end
end

