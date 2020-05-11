defmodule AOFF.Blogs.Blog do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias AOFF.Uploader.Image
  alias AOFF.Blogs.BlogPost

  @derive {Phoenix.Param, key: :title}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "blogs" do
    field :description, :string
    field :title, :string
    field :image, Image.Type
    field :identifier, :string
    field :locale, :string, default: "da"
    field :position, :integer, default: 0
    has_many :blog_posts, BlogPost
    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:title, :description, :identifier, :locale, :position])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:title, :description, :identifier, :locale])
    |> unique_constraint(:identifier, name: :blogs_identifier_locale_index)
    |> unique_constraint(:title, name: :blogs_title_locale_index)
  end

  def image_url(post, field) do
    %{file_name: file_name} = field
    AOFF.Uploader.Image.url({file_name, post})
  end
end
