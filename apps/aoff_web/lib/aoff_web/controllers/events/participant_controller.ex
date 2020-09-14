defmodule AOFFWeb.Events.ParticipantController do
  use AOFFWeb, :controller

  alias AOFF.Events
  alias AOFF.Events.Participant
  alias AOFF.Content



  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authorize_user when action in [:edit, :new, :update, :create, :delete]

  plug :navbar when action in [ :new, :edit]


  # def index(conn, _params) do
  #   participants = Event.list_participants()
  #   render(conn, "index.html", participants: participants)
  # end

  def new(conn, %{"calendar_id" => calendar_id}) do
    page = Content.get_page(calendar_id)
    changeset = Events.change_participant(%Participant{})
    render(
      conn,
      "new.html",
      changeset: changeset,
      page: page,
      page_id: page.id,
      user_id: conn.assigns.current_user.id
    )
  end

  def create(conn, %{"participant" => participant_params}) do
    page = Content.get_page(participant_params["page_id"])
    case Events.create_participant(participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant created successfully.")
        |> redirect(to: Routes.calendar_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        page = Content.get_page(participant_params["page_id"])
        render(
          conn,
          "new.html",
          changeset: changeset,
          page: page,
          page_id: page.id,
          user_id: conn.assigns.current_user.id
        )
    end
  end

  def show(conn, %{"id" => id}) do
    participant = Events.get_participant(id)
    render(conn, "show.html", participant: participant)
  end

  def edit(conn, %{"calendar_id" => calendar_id, "id" => id}) do

    page = Content.get_page(calendar_id)
    participant = Events.get_participant(id)
    changeset = Events.change_participant(participant)
    render(
      conn,
      "edit.html",
      changeset: changeset,
      page: page,
      page_id: page.id,
      user_id: conn.assigns.current_user.id,
      participant: participant
    )
  end

  def update(conn, %{"id" => id, "participant" => participant_params
  }) do
    attrs = Map.drop(participant_params, ["user_id", "page_id"])
    participant = Events.get_participant(id)
    page = Content.get_page(participant.page_id)
    case Events.update_participant(participant, attrs) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant updated successfully.")
        |> redirect(to: Routes.calendar_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset
        render(
        conn,
        "edit.html",
        changeset: changeset,
        page: page,
        page_id: page.id,
        user_id: participant_params["user_id"],
        participant: participant
      )
    end
  end

  def delete(conn, %{"id" => id}) do
    participant = Events.get_participant(id)
    {:ok, participant} = Events.delete_participant(participant)

    conn
    |> put_flash(:info, gettext("Participant deleted successfully."))
    |> redirect(to: Routes.calendar_path(conn, :show, participant.page))
  end

  defp authorize_user(conn, _opts) do
    if conn.assigns.current_user do
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
