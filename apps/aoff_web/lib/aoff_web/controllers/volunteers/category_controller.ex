defmodule AOFFWeb.Volunteer.CategoryController do
  use AOFFWeb, :controller

  alias AOFF.Content.Category
  alias AOFF.Content

  alias AOFFWeb.Users.Auth
  alias AOFF.System
  plug Auth
  plug :authorize_volunteer when action in [:index]
  plug :authorize_admin when action in [:new, :delete]

  plug :navbar when action in [:index, :new, :edit]

  def index(conn, _params) do
    conn = assign(conn, :selected_menu_item, :volunteer)
    {:ok, help_text} =
      System.find_or_create_message(
        "/volunteer/categories",
        "Categories",
        Gettext.get_locale()
      )

    categories = Content.list_categories(:all)
    render(conn, "index.html", categories: categories, help_text: help_text)
  end

  def new(conn, _params) do
    changeset = Content.change_category(%Category{})
    render(conn, "new.html", changeset: changeset, category: false)
  end

  def create(conn, %{"category" => category_params}) do
    case Content.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, gettext("Please update the default image."))
        |> redirect(to: Routes.volunteer_category_path(conn, :edit, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, category: false)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   if category = Content.get_category!(:all, id) do
  #     render(conn, "show.html", category: category)
  #   else
  #     conn
  #     |> put_flash(:error, gettext("The category for the selected language does not exist."))
  #     |> redirect(to: Routes.volunteer_category_path(conn, :index))
  #   end
  # end

  def edit(conn, %{"id" => id}) do
    if category = Content.get_category!(id) do
      changeset = Content.change_category(category)

      render(
        conn,
        "edit.html",
        category: category,
        changeset: changeset,
        image_format: image_format()
      )
    else
      conn
      |> put_flash(:error, gettext("The category for the selected language does not exist."))
      |> redirect(to: Routes.about_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Content.get_category!(id)

    case Content.update_category(category, category_params) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, gettext("Category updated successfully."))
        |> redirect(to: Routes.about_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          category: category,
          changeset: changeset,
          image_format: image_format()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Content.get_category!(id)
    {:ok, _category} = Content.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.about_path(conn, :index))
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
    conn
    |> assign(:selected_menu_item, :about_aoff)
    |> assign(:title, gettext("About AOFF"))
  end

  defp image_format() do
    {:ok, message} =
      System.find_or_create_message(
        "/volunteer/categorys/:id/edit",
        "Image format",
        Gettext.get_locale()
      )

    message
  end
end
