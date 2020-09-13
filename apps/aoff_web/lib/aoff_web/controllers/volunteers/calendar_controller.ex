defmodule AOFFWeb.Volunteer.CalendarController do
  use AOFFWeb, :controller
  alias AOFF.Content
  alias AOFF.Content.Page
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authorize_volunteer when action in [:edit, :new, :update, :create, :delete]

  plug :navbar when action in [:index, :new, :show, :edit]

  def new(conn, _params) do
    category = Content.find_or_create_category("Calendar")
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

  def create(conn, %{"page" => page_attrs}) do
    {:ok, category} = Content.find_or_create_category("Calendar")
    page_attrs = Map.put(page_attrs, "category_id", category.id)

    case Content.create_page(page_attrs) do
      {:ok, page} ->
        conn
        |> put_flash(:info, gettext("Please update the default image."))
        |> redirect(to: Routes.volunteer_calendar_path(conn, :edit, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          category: category,
          author: page_attrs["author"],
          date: page_attrs["date"],
          page: false
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    {:ok, category} = Content.find_or_create_category("Calendar")

    if page = Content.get_page!(category.title, id) do
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

  def update(conn, %{"id" => id, "page" => page_params}) do
    {:ok, category} = Content.find_or_create_category("Calendar")
    page = Content.get_page!(category.title, id)

    case Content.update_page(page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, gettext("Event updated successfully."))
        |> redirect(to: Routes.calendar_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
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
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Content.get_page(id)
    {:ok, _page} = Content.delete_page(page)

    conn
    |> put_flash(:info, gettext("Event deleted successfully."))
    |> redirect(to: Routes.calendar_path(conn, :index))
  end

  defp image_format() do
    {:ok, message} =
      AOFF.System.find_or_create_message(
        "/volunteer/category/:id/edit",
        "Image format",
        Gettext.get_locale()
      )

    message
  end

  defp authorize_volunteer(conn, _opts) do
    if conn.assigns.text_editor || conn.assigns.admin do
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
    assign(conn, :selected_menu_item, :calendar)
  end
end
