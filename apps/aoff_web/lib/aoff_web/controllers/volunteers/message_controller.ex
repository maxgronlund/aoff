defmodule AOFFWeb.Volunteer.MessageController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.System.Message

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :edit, :new, :update, :create, :delete]
  plug :navbar when action in [:index, :new, :show, :edit]

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

  def edit(conn, %{"id" => id}) do
    message = System.get_message!(id)
    changeset = System.change_message(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = System.get_message!(id)

    case System.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, gettext("Message updated successfully."))
        |> redirect(to: Routes.volunteer_message_path(conn, :show, message))

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
    if conn.assigns.current_user && conn.assigns.current_user.volunteer do
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
    conn = assign(conn, :page, :volunteer)
  end
end
