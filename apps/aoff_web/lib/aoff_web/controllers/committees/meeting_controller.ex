defmodule AOFFWeb.Committees.MeetingController do
  use AOFFWeb, :controller

  alias AOFF.Committees
  alias AOFF.Committees.Meeting

  def index(conn, _params) do
    meetings = Committees.list_meetings()
    render(conn, "index.html", meetings: meetings)
  end

  # def new(conn, %{"committee_id" => committee_id}) do
  #   committee = Committees.get_committee!(committee_id)
  #   changeset = Committees.change_meeting(%Meeting{date: Date.add(Date.utc_today(), 14)})
  #   render(conn, "new.html", changeset: changeset, committee: committee)
  # end

  # def create(conn, %{"meeting" => meeting_params}) do
  #   committee = Committees.get_committee!(meeting_params["committee_id"])

  #   case Committees.create_meeting(meeting_params) do
  #     {:ok, meeting} ->
  #       conn
  #       |> put_flash(:info, "Meeting created successfully.")
  #       |> redirect(to: Routes.committee_committee_meeting_path(conn, :show, committee, meeting))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset, committee: committee)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    meeting = Committees.get_meeting!(id)
    render(conn, "show.html", committee: meeting.committee, meeting: meeting)
  end

  # def edit(conn, %{"id" => id}) do
  #   meeting = Committees.get_meeting!(id)
  #   changeset = Committees.change_meeting(meeting)
  #   render(conn, "edit.html", meeting: meeting, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "meeting" => meeting_params}) do
  #   meeting = Committees.get_meeting!(id)

  #   case Committees.update_meeting(meeting, meeting_params) do
  #     {:ok, meeting} ->
  #       conn
  #       |> put_flash(:info, "Meeting updated successfully.")
  #       |> redirect(to: Routes.committee_committee_meeting_path(conn, :show, meeting))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", meeting: meeting, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   meeting = Committees.get_meeting!(id)
  #   {:ok, _meeting} = Committees.delete_meeting(meeting)

  #   conn
  #   |> put_flash(:info, "Meeting deleted successfully.")
  #   |> redirect(to: Routes.committee_committee_meeting_path(conn, :index))
  # end
end
