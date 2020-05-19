defmodule AOFF.Repo.Migrations.RenameBlogsToCategories do
  use Ecto.Migration

  def change do
    drop unique_index(:blogs, [:identifier, :locale])
    drop unique_index(:blogs, [:title, :locale])
    drop unique_index(:blog_posts, [:blog_id, :title])
    rename table(:blog_posts), :blog_id, to: :category_id
    rename table("blogs"), to: table("categories")
    rename table("blog_posts"), to: table("pages")
    create unique_index(:categories, [:identifier, :locale])
    create unique_index(:categories, [:title, :locale])
    create unique_index(:pages, [:category_id, :title])
  end
end
