defmodule AOFFWeb.Volunteer.PageController do
  use AOFFWeb, :controller

  # alias AOFF.Blogs
  alias AOFF.Content.Page
  alias AOFF.Content

  alias AOFFWeb.Users.Auth
  alias AOFF.System
  plug Auth
  # plug :authorize_volunteer when action in [:index]
  plug :authorize_volunteer when action in [:edit, :new, :update, :create, :delete]

  plug :navbar when action in [:index, :new, :show, :edit]

  # def index(conn, _params) do

  #   {:ok, help_text} =
  #     System.find_or_create_message(
  #       "/volunteer/categorys",
  #       "Categories",
  #       Gettext.get_locale()
  #     )

  #   categories = Content.list_categories()
  #   render(conn, "index.html", categories: categories, help_text: help_text)
  # end

  def new(conn, %{"category_id" => category_id}) do
    category = Content.get_category!(category_id)
    changeset = Content.change_page(%Page{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      category: category,
      author: conn.assigns.current_user.username,
      date: Date.utc_today(),
      page: false
    )
  end

  def create(conn, %{"category_id" => category_id, "page" => page_attrs}) do
    category = Content.get_category!(category_id)
    page_attrs = Map.put(page_attrs, "category_id", category.id)

    case Content.create_page(page_attrs) do
      {:ok, page} ->
        conn
        |> put_flash(:info, gettext("Please update the default image."))
        |> redirect(to: Routes.volunteer_category_page_path(conn, :edit, category, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          category: category,
          author: page_attrs["author"],
          date: page_attrs["date"]
        )
    end
  end

  def edit(conn, %{"category_id" => category_id, "id" => id}) do
    if page = Content.get_page!(category_id, id) do
      changeset = Content.change_page(page)

      render(
        conn,
        "edit.html",
        category: page.category,
        page: page,
        changeset: changeset,
        author: page.author,
        date: page.date,
        image_format: image_format()
      )
    else
      conn
      |> put_flash(:error, gettext("The category for the selected language does not exist."))
      |> redirect(to: Routes.volunteer_category_path(conn, :index))
    end
  end

  def update(conn, %{"category_id" => category_id, "id" => id, "page" => page_params}) do
    page = Content.get_page!(category_id, id)

    case Content.update_page(page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, gettext("Page updated successfully."))
        |> redirect(to: Routes.about_page_path(conn, :show, page.category, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          category: page.category,
          page: page,
          changeset: changeset,
          author: page.author,
          date: page.date,
          image_format: image_format(),
          page: true
        )
    end
  end

  def delete(conn, %{"category_id" => category_id, "id" => id}) do
    page = Content.get_page!(category_id, id)
    {:ok, _category} = Content.delete_page(page)

    conn
    |> put_flash(:info, "Page deleted successfully.")
    |> redirect(to: Routes.about_path(conn, :show, page.category))
  end

  defp authorize_volunteer(conn, _opts) do
    if conn.assigns.volunteer || conn.assigns.admin do
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
        "/volunteer/category/:id/edit",
        "Image format",
        Gettext.get_locale()
      )

    message
  end
end
