defmodule AOFFWeb.Info.NewsController do
  use AOFFWeb, :controller

  alias AOFF.Blogs
  alias AOFF.Blogs.BlogPost
  alias AOFF.System

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:edit, :new, :update, :create, :delete]

  def index(conn, _params) do
    conn = assign(conn, :page, :news)
    {:ok, news} = Blogs.find_or_create_blog("news", Gettext.get_locale())
    {:ok, message} =
      System.find_or_create_message(
        "/news",
        "For volunteers",
        Gettext.get_locale()
      )

    blog_posts =
      case news.blog_posts do
        %Ecto.Association.NotLoaded{} -> []
        _ -> news.blog_posts
      end

    render(
      conn,
      "index.html",
      news: news,
      blog_posts: blog_posts,
      message: message
    )
  end

  def new(conn, %{"info_id" => blog_id}) do
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



  def create(conn, %{"info_id" => blog_id, "blog_post" => blog_post}) do

    blog = Blogs.get_blog!(blog_id)
    blog_post = Map.put(blog_post, "blog_id", blog.id)


    case Blogs.create_post(blog_post) do
      {:ok, post} ->
        conn
        |> put_flash(:info, gettext("News created successfully."))
        |> redirect(to: Routes.news_path(conn, :show, post, %{"blog_id" => blog.title, "locale" => blog.locale}))

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


  def show(conn, %{"blog_id" => blog_id, "id" => id, "locale" => locale}) do
    conn = assign(conn, :page, :news)
    post = Blogs.get_post!(blog_id, id, locale)
    render(conn, "show.html", post: post, blog: post.blog)
  end

  def edit(conn, %{"info_id" => blog_id, "id" => id}) do
    blog_post = Blogs.get_post!(blog_id, id)
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
  end

  def update(conn, %{"info_id" => blog_id, "id" => id, "blog_post" => post_params}) do
    post = Blogs.get_post!(blog_id, id)
    blog = post.blog
    case Blogs.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, gettext("News updated successfully."))
        |> redirect(to: Routes.news_path(conn, :show, post, %{"blog_id" => blog.title, "locale" => blog.locale}))

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

  def delete(conn, %{"info_id" => blog_id, "id" => id}) do
    post = Blogs.get_post!(blog_id, id)
    blog = post.blog
    {:ok, post} = Blogs.delete_post(post)

    conn
    |> put_flash(:info, gettext("News deleted successfully."))
    |> redirect(to: Routes.news_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user && conn.assigns.current_user.volunteer do
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
