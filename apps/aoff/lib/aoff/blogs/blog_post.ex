defmodule AOFF.Blogs.BlogPost do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Uploader.Image
  alias AOFF.Blogs.Blog
  @derive {Phoenix.Param, key: :title}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "blog_posts" do
    field :author, :string
    field :caption, :string
    field :date, :date
    field :image, Image.Type
    field :teaser, :string
    field :text, :string
    field :title, :string
    field :tag, :string
    belongs_to :blog, Blog
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :blog_id,
      :date,
      :title,
      :caption,
      :teaser,
      :text,
      :author,
      :tag
    ])
    |> cast_attachments(attrs, [:image])
    |> validate_required([
      :blog_id,
      :date,
      :title,
      :text,
      :author
    ])
    |> unique_constraint(:title, name: :blog_posts_blog_id_title_index)
  end

  def image_url(post, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, post})
  end
end
