defmodule AOFFWeb.Events.ParticipantController do
  use AOFFWeb, :controller

  alias AOFF.Events
  alias AOFF.Content

  def create(conn, %{"participant" => participant_params}) do
    Events.create_participant(participant_params)

    page = Content.get_page(participant_params["page_id"])

    redirect(conn, to: Routes.calendar_path(conn, :show, page))
  end

  def delete(conn, %{"id" => id}) do
    participant = Events.get_participant(id)
    Events.delete_participant(participant)
    page = participant.page

    redirect(conn, to: Routes.calendar_path(conn, :show, page))
  end
end
