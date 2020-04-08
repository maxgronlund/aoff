defmodule AOFFWeb.Blogs.BlogController do
  use AOFFWeb, :controller

  alias AOFF.Blogs

  def index(conn, _params) do
    conn = assign(conn, :page, :blog)

    blogs = Blogs.list_blogs(Gettext.get_locale())
    render(conn, "index.html", blogs: blogs)
  end

  # def new(conn, _params) do
  #   changeset = Blogs.change_blog(%Blog{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"blog" => blog_params}) do
  #   case Blogs.create_blog(blog_params) do
  #     {:ok, blog} ->
  #       conn
  #       |> put_flash(:info, "Blog created successfully.")
  #       |> redirect(to: Routes.blog_path(conn, :show, blog))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    conn = assign(conn, :page, :blog)
    blog = Blogs.get_blog!(id)
    render(conn, "show.html", blog: blog)
  end

  # def edit(conn, %{"id" => id}) do
  #   blog = Blogs.get_blog!(id)
  #   changeset = Blogs.change_blog(blog)
  #   render(conn, "edit.html", blog: blog, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "blog" => blog_params}) do
  #   blog = Blogs.get_blog!(id)

  #   case Blogs.update_blog(blog, blog_params) do
  #     {:ok, blog} ->
  #       conn
  #       |> put_flash(:info, "Blog updated successfully.")
  #       |> redirect(to: Routes.blog_path(conn, :show, blog))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", blog: blog, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do

  #   blog = Blogs.get_blog!(id)
  #   {:ok, _blog} = Blogs.delete_blog(blog)

  #   conn
  #   |> put_flash(:info, "Blog deleted successfully.")
  #   |> redirect(to: Routes.blog_path(conn, :index))
  # end
end
