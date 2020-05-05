defmodule AOFFWeb.Volunteer.MessageController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.Users
  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :edit, :new, :update, :create, :delete]


  def index(conn, _params) do
    {:ok, instructions} =
      System.find_or_create_message(
        "/volunteer/messages",
        "Volunteer messages page",
        Gettext.get_locale()
      )

    messages = System.list_messages("da")
    render(conn, "index.html", messages: messages, instructions: instructions)
  end

  def show(conn, %{"id" => id}) do
    message = System.get_message!(id)
    render(conn, "show.html", message: message)
  end

  def edit(conn, %{"id" => id, "request_url" => request_url}) do

    Users.set_bounce_to_url(conn.assigns.current_user, request_url)

    message = System.get_message!(id)
    changeset = System.change_message(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = System.get_message!(id)

    case System.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, gettext("%{title} updated successfully.", title: message.title))
        |> redirect(to: Users.get_bounce_to_url(conn.assigns.current_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = System.get_message!(id)
    {:ok, _message} = System.delete_message(message)

    conn
    |> put_flash(:info, gettext("Message deleted successfully."))
    |> redirect(to: Routes.volunteer_message_path(conn, :index))
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
