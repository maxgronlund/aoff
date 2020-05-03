defmodule AOFF.Repo.Migrations.AddShowOnFrontToBlogPosts do
  use Ecto.Migration

  def change do
    alter table("blog_posts") do
      add :show_on_landing_page, :boolean, default: false
      add :locale, :string, default: "da"
    end
  end
end
