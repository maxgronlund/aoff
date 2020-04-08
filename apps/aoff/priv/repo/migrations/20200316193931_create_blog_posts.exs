defmodule AOFF.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :title, :string
      add :image, :string
      add :caption, :string
      add :teaser, :text
      add :text, :text
      add :author, :string
      add :tag, :string
      add :blog_id, references(:blogs, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:blog_posts, [:blog_id, :title])
  end
end
