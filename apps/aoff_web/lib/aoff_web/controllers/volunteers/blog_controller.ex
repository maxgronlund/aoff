defmodule AOFFWeb.Volunteer.BlogController do
  use AOFFWeb, :controller

  alias AOFF.Blogs
  alias AOFF.Blogs.Blog

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :edit, :new, :update, :create, :delete]
  plug :navbar when action in [:index, :new, :show, :edit]

  def index(conn, _params) do
    blogs = Blogs.list_blogs(Gettext.get_locale())
    render(conn, "index.html", blogs: blogs)
  end

  def new(conn, _params) do
    changeset = Blogs.change_blog(%Blog{})
    render(conn, "new.html", changeset: changeset, blog: false)
  end

  def create(conn, %{"blog" => blog_params}) do
    case Blogs.create_blog(blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, gettext("Please update the default image."))
        |> redirect(to: Routes.volunteer_blog_path(conn, :edit, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, blog: false)
    end
  end

  def show(conn, %{"id" => id}) do
    if blog = Blogs.get_blog!(id) do
      render(conn, "show.html", blog: blog)
    else
      conn
      |> put_flash(:error, gettext("You can only show a category in one language."))
      |> redirect(to: Routes.volunteer_blog_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    if blog = Blogs.get_blog!(id) do
      changeset = Blogs.change_blog(blog)
      render(conn, "edit.html", blog: blog, changeset: changeset)
    else
      conn
      |> put_flash(:error, gettext("You can only edit a category in one language."))
      |> redirect(to: Routes.volunteer_blog_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Blogs.get_blog!(id)

    case Blogs.update_blog(blog, blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, gettext("Category updated successfully."))
        |> redirect(to: Routes.volunteer_blog_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Blogs.get_blog!(id)
    {:ok, _blog} = Blogs.delete_blog(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: Routes.volunteer_blog_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  defp navbar(conn, _opts) do
    assign(conn, :page, :volunteer)
  end
end
