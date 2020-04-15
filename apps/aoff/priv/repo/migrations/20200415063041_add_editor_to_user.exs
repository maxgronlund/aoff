defmodule AOFF.Repo.Migrations.AddEditorToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :text_editor, :boolean, default: false
      # add :manage_membership, :boolean, default: :false
    end
  end
end
