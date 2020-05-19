defmodule AOFFWeb.Volunteer.CategoryController do
  use AOFFWeb, :controller

  # alias AOFF.Blogs
  alias AOFF.Blogs.Blog
  alias AOFF.Content

  alias AOFFWeb.Users.Auth
  alias AOFF.System
  plug Auth
  plug :authorize_volunteer when action in [:index]
  plug :authorize_admin when action in [:edit, :new, :update, :create, :delete]

  plug :navbar when action in [:index, :new, :show, :edit]

  def index(conn, _params) do
    {:ok, help_text} =
      System.find_or_create_message(
        "/volunteer/blogs",
        "Categories",
        Gettext.get_locale()
      )

    categories = Content.list_categories()
    render(conn, "index.html", categories: categories, help_text: help_text)
  end

  def new(conn, _params) do
    changeset = Content.change_category(%Blog{})
    render(conn, "new.html", changeset: changeset, blog: false)
  end

  def create(conn, %{"blog" => blog_params}) do
    case Content.create_category(blog_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, gettext("Please update the default image."))
        |> redirect(to: Routes.volunteer_category_path(conn, :edit, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, blog: false)
    end
  end

  def show(conn, %{"id" => id}) do
    if blog = Blogs.get_blog!(id) do
      render(conn, "show.html", blog: blog)
    else
      conn
      |> put_flash(:error, gettext("The category for the selected language does not exist."))
      |> redirect(to: Routes.volunteer_blog_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    if blog = Content.get_category!(id) do
      changeset = Content.change_category(blog)

      render(
        conn,
        "edit.html",
        blog: blog,
        changeset: changeset,
        image_format: image_format()
      )
    else
      conn
      |> put_flash(:error, gettext("The category for the selected language does not exist."))
      |> redirect(to: Routes.volunteer_category_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Content.get_category!(id)

    case Content.update_category(blog, blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, gettext("Category updated successfully."))
        |> redirect(to: Routes.volunteer_category_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          blog: blog,
          changeset: changeset,
          image_format: image_format()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Content.get_category!(id)
    {:ok, _blog} = Content.delete_category(blog)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.volunteer_category_path(conn, :index))
  end

  defp authorize_volunteer(conn, _opts) do
    if conn.assigns.volunteer || conn.assigns.admin do
      conn
    else
      forbidden(conn)
    end
  end

  defp authorize_admin(conn, _opts) do
    if conn.assigns.admin do
      conn
    else
      forbidden(conn)
    end
  end

  defp forbidden(conn) do
    conn
    |> put_status(401)
    |> put_view(AOFFWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end

  defp navbar(conn, _opts) do
    assign(conn, :page, :volunteer)
  end

  defp image_format() do
    {:ok, message} =
      System.find_or_create_message(
        "/volunteer/blogs/:id/edit",
        "Image format",
        Gettext.get_locale()
      )

    message
  end
end
