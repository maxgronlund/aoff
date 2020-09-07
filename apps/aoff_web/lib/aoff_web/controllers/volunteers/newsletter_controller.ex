defmodule AOFFWeb.Volunteer.NewsletterController do
  use AOFFWeb, :controller

  alias AOFF.Volunteers
  alias AOFF.Volunteer.Newsletter
  # alias AOFF.Users
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show, :edit, :new, :update, :create, :delete]

  def index(conn, _params) do
    newsletters = Volunteers.list_newsletters()
    render(conn, "index.html", newsletters: newsletters)
  end

  def new(conn, _params) do
    changeset = Volunteers.change_newsletter(%Newsletter{})
    render(conn, "new.html", changeset: changeset, newsletter: false)
  end

  def create(conn, %{"newsletter" => newsletter_params}) do
    case Volunteers.create_newsletter(newsletter_params) do
      {:ok, newsletter} ->
        conn
        |> put_flash(:info, gettext("News letter created successfully."))
        |> redirect(to: Routes.volunteer_newsletter_path(conn, :show, newsletter))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, newsletter: false)
    end
  end

  def show(conn, %{"id" => id}) do
    newsletter = Volunteers.get_newsletter!(id)
    render(conn, "show.html", newsletter: newsletter)
  end

  def edit(conn, %{"id" => id}) do
    newsletter = Volunteers.get_newsletter!(id)
    changeset = Volunteers.change_newsletter(newsletter)
    render(conn, "edit.html", newsletter: newsletter, changeset: changeset)
  end

  def update(conn, %{"id" => id, "newsletter" => newsletter_params}) do
    newsletter = Volunteers.get_newsletter!(id)

    case Volunteers.update_newsletter(newsletter, newsletter_params) do
      {:ok, newsletter} ->
        conn
        |> put_flash(:info, gettext("News letter updated successfully."))
        |> redirect(to: Routes.volunteer_newsletter_path(conn, :show, newsletter))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", newsletter: newsletter, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    newsletter = Volunteers.get_newsletter!(id)
    {:ok, _newsletter} = Volunteers.delete_newsletter(newsletter)

    conn
    |> put_flash(:info, gettext("News letter deleted successfully."))
    |> redirect(to: Routes.volunteer_newsletter_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.volunteer do
      assign(conn, :selected_menu_item, :volunteer)
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
