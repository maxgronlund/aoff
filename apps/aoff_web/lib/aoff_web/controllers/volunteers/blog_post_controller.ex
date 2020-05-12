defmodule AOFFWeb.Volunteer.BlogPostController do
  use AOFFWeb, :controller

  alias AOFF.Blogs
  alias AOFF.Blogs.BlogPost
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :edit, :new, :update, :create, :delete]

  # def index(conn, params) do

  #   posts = Blogs.list_posts()
  #   render(conn, "index.html", posts: posts, blog: blog)
  # end

  def new(conn, %{"blog_id" => blog_id}) do
    blog = Blogs.get_blog!(blog_id)
    changeset = Blogs.change_post(%BlogPost{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      blog: blog,
      author: conn.assigns.current_user.username,
      date: Date.utc_today(),
      blog_post: false
    )
  end

  def create(conn, %{"blog_id" => blog_id, "blog_post" => blog_post}) do
    blog = Blogs.get_blog!(blog_id)
    blog_post = Map.put(blog_post, "blog_id", blog.id)

    case Blogs.create_post(blog_post) do
      {:ok, post} ->
        conn
        |> put_flash(:info, gettext("Please update the default image."))
        |> redirect(to: Routes.volunteer_blog_blog_post_path(conn, :edit, blog, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          blog: blog,
          author: blog_post["author"],
          date: blog_post["date"],
          blog_post: false
        )
    end
  end

  def show(conn, %{"blog_id" => blog_id, "id" => id}) do
    post = Blogs.get_post!(blog_id, id)
    render(conn, "show.html", post: post, blog: post.blog)
  end

  def edit(conn, %{"blog_id" => blog_id, "id" => id}) do
    if blog_post = Blogs.get_post!(blog_id, id) do
      changeset = Blogs.change_post(blog_post)

      render(
        conn,
        "edit.html",
        blog: blog_post.blog,
        blog_post: blog_post,
        changeset: changeset,
        author: blog_post.author,
        date: blog_post.date
      )
    else
    conn
    |> put_flash(:error, gettext("The category for the selected language does not exist."))
    |> redirect(to: Routes.volunteer_blog_path(conn, :index))
    end
  end


  def update(conn, %{"blog_id" => blog_id, "id" => id, "blog_post" => post_params}) do
    post = Blogs.get_post!(blog_id, id)

    case Blogs.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, gettext("Post updated successfully."))
        |> redirect(to: Routes.volunteer_blog_blog_post_path(conn, :show, post.blog, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          post: post,
          changeset: changeset,
          author: post.author,
          date: post.date,
          blog: post.blog,
          blog_post: post
        )
    end
  end

  def delete(conn, %{"blog_id" => blog_id, "id" => id}) do
    post = Blogs.get_post!(blog_id, id)
    blog = post.blog
    {:ok, _post} = Blogs.delete_post(post)

    conn
    |> put_flash(:info, gettext("Post deleted successfully."))
    |> redirect(to: Routes.volunteer_blog_path(conn, :show, blog))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :page, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
